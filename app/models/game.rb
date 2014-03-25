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
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)
#  current_round        :integer          default(1)
#  random_seed          :integer
#  number_of_players    :integer
#  filter_content_by    :json
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
  validates :number_of_players, presence: true, numericality: {greater_than: 1} 

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

  has_many :nodes, dependent: :destroy, autosave: true
  has_many :links, dependent: :destroy, autosave: true

  before_create :generate_random_seed

  # Convenience methods for persisting the seed_thing_id when there are validation errors.
  attr_accessor :seed_thing_id
  after_initialize do |game|
    game.seed_thing_id = seed_thing.try(:id)
  end

  # == State Machine

  state_machine initial: :draft do 
    after_transition :draft => :open, do: :remove_draft_players
    after_transition :draft => :playing, do: :invite_players
    after_transition :rating => :playing, do: :increment_round
    before_transition :rating => [:playing, :completed], do: :calculate_scores
    after_transition :playing => :rating, do: :players_begin_rating
    after_transition :rating => :playing, do: :players_begin_playing

    event :publish do 
      transition :draft => :open, if: lambda { |game| !game.invite_only }
      transition :draft => :playing
    end

    event :unpublish do 
      transition :open => :draft
    end

    # This happens after a player has successfully been created.
    event :join do 
      transition [:open, :joining] => :joining, if: lambda {|game| game.with_open_places? }
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

  # == Helpers
  def with_open_places? 
    number_of_players && players.count < number_of_players
  end 

  def open_to_join?
    invite_only == false && can_join?
  end

  def seed_thing 
    if seed_thing_id.present?
      Thing.find(seed_thing_id)
    else 
      seed_node.try(:final_placement).try(:thing)
    end
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

  # Increment round if all placements have been finalised
  def increment_round
    round_complete = true
    nodes.where(round: current_round).each do |node|
      round_complete = false unless node.final_placement.present?
    end

    self.current_round += 1 if round_complete
  end

  def calculate_scores 
    calculate_placement_scores
    calculate_player_scores
  end

  def calculate_placement_scores 
    nodes.where(round: current_round).each do |node|
      winning_move = nil
      node.placements.with_state('proposed').each do |placement|
        move = Move.new(placement: placement)
        move.calculate_score
        winning_move = move if move.score >= (winning_move.try(:score) || 0)
      end
      # Reify the move with the highest score to the final placement/resemblences
      winning_move.reify
    end
  end

  def calculate_player_scores
    players.each do |player|
      player.calculate_score
      player.save
    end
  end

  # == Validations
  def players_must_not_outnumber_board_number
    if number_of_players && players.count > (number_of_players || 0)
      errors.add(:base, "#{number_of_players} players have already joined this game.")
    end
  end

  def all_players_created
    if number_of_players && players.count < number_of_players
      if invite_only
        errors.add(:base, "This game is invite only. #{number_of_players} players must be invited to publish this game.")
      else 
        errors.add(:base, "#{number_of_players} players are required to publish this game.")
      end
    end
  end

  def uploads_disabled_for_public_game
    if !invite_only && uploads_allowed
      errors.add(:base, "Can only enable uploads on private, invitation only games.")
    end
  end

  def filter_query
    @filter_query ||= Search::ThingQuery.new((filter_content_by || {}).symbolize_keys!)
    puts "filter query " + @filter_query.to_json.inspect
    @filter_query
  end

  # == Stuff that shouln't be here
  
  def crop_board
    xarr = nodes.map {|n| n.x}
    yarr = nodes.map {|n| n.y}

    min_x, max_x = xarr.min, xarr.max
    min_y, max_y = yarr.min, yarr.max

    width = max_x - min_x
    height = max_y - min_y

    scaleX = 800.0/width
    scaleY = 600.0/height

    nodes.each do |node| 
      node.x = (node.x - min_x) * scaleX
      node.y = (node.y - min_y) * scaleY
    end
  end


  private 

    def generate_random_seed
      self.random_seed = SecureRandom.random_number(2147483646)
    end

end
