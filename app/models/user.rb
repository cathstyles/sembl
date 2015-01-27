class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  has_many :games, through: :player
  has_one :player
  has_one :profile

  has_many :created_things, class_name: 'Thing', foreign_key: :creator_id, inverse_of: :creator
  has_many :updated_things, class_name: 'Thing', foreign_key: :updator_id, inverse_of: :updator

  after_create :create_profile, :join_games

  ROLES = {
    :participant => 1,
    :power_user => 2,
    :admin => 10,
    :banned => 0
  }.freeze

  state_machine :role, initial: :participant do
    ROLES.each do |name, value|
      state name, :value => value
    end

    event :make_participant do
      transition all => :participant
    end

    event :make_power_user do
      transition all => :power
    end

    event :make_admin do
      transition all => :admin
    end

    event :ban do
      transition all => :banned
    end
  end

  delegate \
    :avatar,
    :bio,
    :name,
    to: :profile

  def to_s
    email
  end

  def self.roles
    ROLES
  end

  def has_moved?
    Placement.where(creator: self).count > 0
  end

  private

  def join_games
    Player.where(email: email).try(:each) do |player|
      player.user = self
      if player.save
        # Only transition state to playing if player has actually been sent an invitation.
        player.join if player.invited?
      else
        errors.add(:base, "Could not join the game #{player.game.title}, hosted by #{player.game.creator.email}.")
      end
    end
  end

  def create_profile
    self.profile = Profile.create(user: self)
  end
end
