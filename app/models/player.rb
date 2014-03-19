# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float            default(0.0), not null
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      not null
#  email      :string(255)
#  move_state :string(255)
#

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  after_create :allocate_first_node
  after_destroy :remove_node_allocation

  validates :user_id, uniqueness: {scope: :game_id}, allow_nil: true

  # == States
  # draft 
  # invited
  # playing_turn
  # waiting 
  # rating 

  state_machine initial: :draft do 
    after_transition :playing_turn => :waiting, do: :check_turn_completion
    after_transition :rating => :wating, do: :check_rating_completion
    after_transition :draft => any, do: :send_invitation
    after_transition any => :playing_turn do |player, transition|
      player.begin_move
    end

    event :invite do 
      transition :draft => :playing_turn, 
        if: lambda {|player| player.user.present? }
      transition :draft => :invited
    end

    event :join do 
      transition :invited => :playing_turn
    end

    event :end_turn do 
      transition :playing_turn => :waiting,
        if: lambda {|player|  player.move_created? }
    end

    event :begin_rating do 
      transition :waiting => :rating
    end

    event :end_rating do 
      transition :rating => :waiting
    end

    event :begin_turn do 
      transition :waiting => :playing_turn
    end

    state :invited do 
      validates_presence_of :email 
    end

    state :playing_turn do 
      validates_presence_of :user
    end 

  end

  #== Move States
  # open
  # created
  
  state_machine :move_state, initial: :open, namespace: 'move' do 
    event :create do 
      transition :open => :created
    end

    event :begin do 
      transition :created => :open
    end
  end

  def self.playing 
    without_states(:draft, :invited)
  end 

  #TODO record locking.
  def allocate_first_node
    return if game.nodes.where(allocated_to_id: user.id).present?
    node = game.nodes.with_state(:in_play).where(allocated_to_id: nil).take
    if node 
      node.allocated_to = self.user
      node.save!
    end
  end

  def remove_node_allocation 
    node = game.nodes.where(allocated_to_id: id).take
    if node
      node.allocated_to_id = nil
      node.save!
    end
  end

  def check_turn_completion
    if game.players.with_state(:waiting).count == game.number_of_players
      game.turns_completed
    end
  end

  def check_rating_completion
    if game.players.with_state(:waiting).count == game.number_of_players
      game.ratings_completed
    end
  end

  def send_invitation
    PlayerMailer.game_invitation(self).deliver
  end
end
