# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  board_id             :integer
#  title                :string(255)      not null
#  description          :text
#  creator_id           :integer
#  updator_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  invite_only          :boolean          default(FALSE)
#  uploads_allowed      :boolean          default(FALSE)
#  theme                :string(255)
#  filter_content_by    :text
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)
#  current_round        :integer          default(1)
#  random_seed          :integer
#  number_of_players    :integer
#

# == States 
#   draft:     Will not be published
#   open:      Open to join but no players have joined, can still be edited
#   joining:   Players have joined and can begin play, but there are still places available
#   playing:   Players are adding placements and sembls
#   rating:    Players are rating 
#   completed: Game is over 
class Game < ActiveRecord::Base
  validates :title, presence: true
  validates :board, presence: true

  validate :players_must_not_outnumber_board_number

  belongs_to :board

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :players
  has_many :players

  has_many :nodes
  has_many :links

  before_create :generate_random_seed

  state_machine initial: :draft do 

    after_transition :rating => :playing, do: :increment_round
    after_transition :playing => :rating, do: :players_begin_rating
    after_transition :rating => :playing, do: :players_begin_playing

    event :publish do 
      transition :draft => :open
    end

    event :unpublish do 
      transition :open => :draft
    end

    event :join do 
      transition [:open, :joining] => :joining, if: lambda {|game| game.has_open_places? }
      transition [:joining, :open] => :playing
    end

    event :turns_completed do 
      transition :playing => :rating
    end

    event :ratings_completed do 
      transition :rating => :completed, if: lambda {|game| game.final_round? }
      transition :rating => :playing
    end

    # TODO This probably needs to be more fine grained. Some fields like description
    # should be editable after play begins.
    state :draft, :open do
      def editable? 
        true
      end
    end

    state :joining, :playing, :rating, :complete do
      def editable? 
        false
      end
    end

  end

  # Games still open to users to join
  def self.open_to_join
    where(invite_only: false).with_states(:joining, :open)
  end

  def self.in_progress
    with_states(:open, :joining, :playing, :rating)
  end

  def self.invite_only
    where(invite_only: true)
  end

  def self.participating(current_user)
      joins(:users).where(["users.id = ?", current_user.try(:id)])
  end

  def self.hosted_by(current_user)
    where(creator: current_user)
  end

  def has_open_places? 
    players.count < board.number_of_players
  end 

  def open_to_join?
    invite_only == false && can_join?
  end

  def increment_round
    self.current_round += 1
  end

  def seed_thing 
    seed_node.try(:final_placement).try(:thing)
  end

  def seed_node 
    nodes.where(round: 0).take
  end

  def final_round 
    nodes.maximum(:round)
  end

  def final_round? 
    current_round == final_round
  end

  def participating?(user)
    users.include?(user)
  end

  def hosting?(user)
    creator == user
  end

  def player(current_user)
    players.where(user: current_user).take
  end

  def players_must_not_outnumber_board_number
    if board && players.count > board.number_of_players
      errors.add(:players, "can't be more than #{board.number_of_players}")
    end
  end

  def players_begin_playing
    players.each {|player| player.begin_turn }
  end

  def players_begin_rating
    players.each {|player| player.begin_rating }
  end


  # Copy nodes and links from board
  def copy_board_to_game
    return unless board.present? 

    nodes.destroy_all
    links.destroy_all

    node_array = []
    board.nodes_attributes.each do |node_attr|
      node_array << nodes.build(node_attr.except('fixed'))
    end

    board.links_attributes.each do |link_attr| 
      links.build(
        source: node_array[link_attr['source']],
        target: node_array[link_attr['target']]
      )
    end

    self.number_of_players = board.number_of_players
  end



  private 

    def generate_random_seed
      self.random_seed = SecureRandom.random_number(2147483646)
    end

end
