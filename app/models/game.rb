# Game reminder emails
#
# Some game reminder emails are sent after it sits in various states for too
# long. See the `state_changed_at` and `reminder_count_for_state` attributes
# for how these reminders are handled.

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
  validates :seed_thing_id, presence: true
  #validates :number_of_players, presence: true, numericality: {greater_than: 1}

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

  default_scope order('created_at DESC')

  before_create :generate_random_seed
  before_save :set_state_changed_at

  # Convenience methods for persisting the seed_thing_id when there are validation errors.
  attr_accessor :seed_thing_id
  after_initialize do |game|
    game.seed_thing_id = seed_thing.try(:id)
  end

  # == State Machine

  state_machine initial: :draft do
    after_transition :draft => :open, do: :remove_draft_players
    after_transition :draft => :playing, do: :invite_players
    after_transition [:draft, :open, :joining] => :playing, do: :deliver_game_started_notifications
    after_transition :rating => :playing, do: :increment_round
    before_transition :rating => [:playing, :completed], do: :calculate_scores
    after_transition :playing => :rating, do: :players_begin_rating
    after_transition :rating => :playing, do: :players_begin_playing
    after_transition :rating => :completed, do: :players_finish_playing
    after_transition :rating => :completed, do: :deliver_game_completed_notifications
    after_transition any => any, do: :reset_reminder_count_for_state

    event :publish do
      transition :draft => :open, if: lambda { |game| !game.invite_only }
      transition :draft => :playing
    end

    event :unpublish do
      transition :open => :draft
    end

    # This happens after a player has successfully been created.
    event :join do
      transition [:open, :joining] => :joining, if: lambda { |game| game.with_open_places? }
      transition [:joining, :open] => :playing
    end

    event :turns_completed do
      transition :playing => :rating
    end

    event :ratings_completed do
      transition :rating => :completed, if: lambda { |game| game.final_round? }
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

  def self.hostless
    where(creator_id: nil)
  end

  def self.not_stale
    where(stale: false)
  end

  def self.requiring_stale_and_incomplete_player_set_notification
    with_states(:open, :joining).
      where(reminder_count_for_state: 0).
      where("
        (number_of_players >= ? AND number_of_players <= ? AND state_changed_at < ?) OR
        (number_of_players > ? AND state_changed_at < ?)",
        3, 6, 3.days.ago,
        6,    3.days.ago)
  end

  # == Helpers
  def with_open_places?
    number_of_players && players.count < number_of_players
  end

  def open_to_join?
    invite_only == false && can_join?
  end

  def hostless?
    creator_id == nil
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
    creator.present? && user.present? && creator == user
  end

  def player(current_user)
    players.where(user: current_user).take unless !current_user
  end

  # == Transition callbacks
  def players_begin_playing
    players.each {|player| player.begin_turn }
  end

  def players_begin_rating
    players.each {|player| player.begin_rating }
  end

  def players_finish_playing
    players.each {|player| player.finish_playing }
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

    if round_complete
      self.current_round += 1
      save!
      unlock_nodes_for_round
    end
  end

  def unlock_nodes_for_round
    nodes.where(round: current_round).each do |node|
      node.unlock
    end
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
      winning_move.reify unless winning_move.nil?
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
    filter_params = (filter_content_by || {}).symbolize_keys!
    filter_params[:game_id] = id

    @filter_query ||= Search::ThingQuery.new(filter_params)
    @filter_query.random_seed = random_seed
    @filter_query
  end

  def copy_nodes_and_links_from_board
    return unless board_id.present? && board_id_changed?
    if !draft?
      errors.add(:base, "Cannot change board once published")
    end

    # So they are not destroyed if validation fails.
    nodes.each {|n| n.mark_for_destruction }
    links.each {|l| l.mark_for_destruction }

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

  # == Stuff that shouln't be here

  def crop_board
    xarr = nodes.map {|n| n.x}
    yarr = nodes.map {|n| n.y}

    min_x, max_x = xarr.min, xarr.max
    min_y, max_y = yarr.min, yarr.max

    width = max_x - min_x
    height = max_y - min_y
    width = 800 if width == 0
    height = 600 if height == 0

    scaleX = 800.0/width
    scaleY = 600.0/height

    nodes.each do |node|
      node.x = (node.x - min_x) * scaleX
      node.y = (node.y - min_y) * scaleY
    end
  end

  ### Commands

  def deliver_game_started_notifications
    players.each do |player|
      DeliverEmailJob.enqueue("GameMailer", "game_started", player.id)
    end
  end

  def deliver_game_completed_notifications
    players.each do |player|
      DeliverEmailJob.enqueue("GameMailer", "game_completed", player.id)
    end
  end

  def deliver_stale_and_incomplete_player_set_notifications
    increment! :reminder_count_for_state

    players.each do |player|
      DeliverEmailJob.enqueue("GameMailer", "game_stale_and_incomplete_player_set", player.id)
    end
  end

  private

    def generate_random_seed
      self.random_seed = SecureRandom.random_number(2147483646)
    end

    def set_state_changed_at
      self.state_changed_at = Time.current if state_changed?
    end

    def reset_reminder_count_for_state
      update reminder_count_for_state: 0
    end
end
