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
  validate :uploads_disabled_for_public_game
  validate :players_must_not_outnumber_board_number

  belongs_to :board
  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :players
  has_many :players

  accepts_nested_attributes_for :players, 
    allow_destroy: true,
    reject_if: :all_blank

  has_many :nodes
  has_many :links

  before_create :generate_random_seed

  # == State Machine

  state_machine initial: :draft do 
    after_transition :draft => :open, do: :remove_draft_players
    after_transition :draft => :playing, do: :invite_players
    after_transition :rating => :playing, do: :increment_round
    after_transition :playing => :rating, do: :players_begin_rating
    after_transition :rating => :playing, do: :players_begin_playing

    event :publish do 
      transition :draft => :open, if: lambda { |game| !game.invite_only }
      transition :draft => :playing
    end

    event :unpublish do 
      transition :draft => :draft
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

    state :draft, :open do
      def configurable? 
        true
      end
    end

    state :joining, :playing, :rating, :complete do
      def configurable? 
        false
      end
    end

    # validate correct number of players have been invited.
    state :playing do
      validate :all_players_created
    end 

  end

  # == Scopes

  # Games still open to users to join
  def self.open_to_join
    where(invite_only: false).with_states(:joining, :open)
  end

  def self.participating(current_user)
      joins(:users).where(["users.id = ?", current_user.try(:id)])
  end

  def self.hosted_by(current_user)
    where(creator: current_user)
  end

  # Helpers
  def has_open_places? 
    number_of_players && players.count < number_of_players
  end 

  def open_to_join?
    invite_only == false && can_join?
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

  # == Transition callbacks
  def players_begin_playing
    players.each {|player| player.begin_turn }
  end

  def players_begin_rating
    players.each {|player| player.begin_rating }
  end

  def invite_players 
    players.each do |player|
      player.invite
    end if invite_only
  end 

  def remove_draft_players
    players.with_state(:draft).destroy_all 
  end

  def increment_round
    self.current_round += 1
  end

  # == Validations
  def players_must_not_outnumber_board_number
    if number_of_players && players.count > (number_of_players || 0)
      errors.add(:base, "#{number_of_players} players have already joined this game.")
    end
  end

  def all_players_created
    if number_of_players && players.count < number_of_players
      errors.add(:base, "#{number_of_players} players are required to publish this game.")
    end
  end

  def uploads_disabled_for_public_game
    if !invite_only && uploads_allowed
      errors.add(:base, "Can only enable uploads on private, invitation only games.")
    end
  end

  # == Stuff that shouln't be here
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
