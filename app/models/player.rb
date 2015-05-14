# Player reminder emails
#
# Some player reminder emails are sent after it sits in various states for too
# long. See the `state_changed_at` and `reminder_count_for_state` attributes
# for how these reminders are handled.

class Player < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  after_create :allocate_first_node
  before_save :set_state_changed_at
  before_save { |player| player.email = player.email.downcase if player.email.present? } # Force lowercase email addresses
  # Invite to already open games
  after_create { |player| player.deliver_invitation if !player.game.draft? && player.game.joining?}
  after_destroy :remove_node_allocation

  validates :user_id, uniqueness: {scope: :game_id}, allow_nil: true

  # == States
  # draft
  # invited
  # playing_turn
  # waiting
  # rating
  # finished

  state_machine initial: :draft do
    after_transition :playing_turn => :waiting, do: :check_turn_completion
    after_transition :rating => :waiting, do: :check_rating_completion
    after_transition :draft => any, do: :deliver_invitation
    after_transition [:invited, :draft] => :playing_turn, do: :allocate_first_node
    after_transition any => :playing_turn do |player, transition|
      player.begin_move
    end
    after_transition any => any, do: :reset_reminder_count_for_state

    event :invite do
      transition :draft => :playing_turn, if: lambda { |player| player.user.present? }
      transition :draft => :invited
    end

    event :join do
      transition :invited => :playing_turn
    end

    event :end_turn do
      transition :playing_turn => :waiting, if: lambda { |player| player.move_created? }
    end

    event :force_end_turn do
      transition :playing_turn => :waiting
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

    event :finish_playing do
      transition [:rating, :waiting] => :finished
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

  delegate \
    :avatar,
    :bio,
    :name,
    to: :user

  def self.playing
    without_states(:draft, :invited)
  end

  def self.requiring_invitation_reminder
    with_states(:invited).where("reminder_count_for_state = ? AND state_changed_at < ?", 1, 1.day.ago)
  end

  def self.requiring_turn_reminder
    with_states(:playing_turn, :rating).where("
      (reminder_count_for_state = ? AND state_changed_at < ?) OR
      (reminder_count_for_state = ? AND state_changed_at < ?) OR
      (reminder_count_for_state = ? AND state_changed_at < ?) OR
      (reminder_count_for_state = ? AND state_changed_at < ?)",
      0, 4.hours.ago,
      1, 1.day.ago,
      2, 2.days.ago,
      3, 7.days.ago
    )
  end

  def deliver_invitation
    increment! :reminder_count_for_state
    DeliverEmailJob.enqueue("GameMailer", "player_invitation", id)
  end

  def deliver_invitation_reminder
    deliver_invitation
  end

  def deliver_turn_reminder
    increment! :reminder_count_for_state
    DeliverEmailJob.enqueue("GameMailer", "player_turn_reminder", id)
  end

  #TODO record locking.
  def allocate_first_node
    # Invited players don't get allocated a node until transitioned to playing_turn
    # Self joining players always get allocated a node because they are in playing_turn state on Player.create
    if playing_turn?
      return if game.nodes.where(allocated_to_id: user.id).present?
      node = game.nodes.with_state(:in_play).where(allocated_to_id: nil).take
      if node
        node.allocated_to = self.user
        node.save!
      end
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
      game.ratings_completed!
    end
  end

  # Average of all placement scores for game
  def calculate_score
    self.score = Placement.joins(:node).where("nodes.game_id = ? AND creator_id = ? AND score IS NOT NULL", game.id, user.id).average(:score)
  end

  private

  def set_state_changed_at
    self.state_changed_at = Time.current if state_changed?
  end

  def reset_reminder_count_for_state
    update reminder_count_for_state: 0
  end
end
