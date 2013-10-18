class Game < ActiveRecord::Base
  validates :title, presence: true
  belongs_to :board

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  has_many :users, through: :players
  has_many :players


  # Games still open to users to join
  def self.open_to_join
    where(invite_only: false).
      joins(:users, :board).
      group("games.id, boards.number_of_players").
      having("count(users.id) < boards.number_of_players")
  end

  def self.completed
    where(state: 'completed')
  end

  def self.in_progress
    where("state != 'draft' AND state != 'completed'")
  end

  def self.invite_only
    where(invite_only: true)
  end

  def self.participating(current_user)
    joins(:users).where(["users.id = ?", current_user.id])
  end

  def self.hosted_by(current_user)
    where(creator: current_user)
  end

end
