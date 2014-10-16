class Resemblance < ActiveRecord::Base
  validates_presence_of :description
  belongs_to :link

  # A resemeblance needs two placements, because every resemblance between the same two nodes
  # can have a different target placement. So knowing about the link, and thus the nodes, is not enough.
  belongs_to :source, class_name: "Placement"
  belongs_to :target, class_name: "Placement"

  belongs_to :creator, class_name: "User"

  has_many :ratings

  # == States
  #   proposed
  #   final
  state_machine initial: :proposed do
    event :reify do
      transition :proposed => :final
    end
  end

  def rating_by(user)
    ratings.where(creator: user).take
  end

  def calculate_score
    self.score = ratings.average(:rating)
  end

  def self.for_game(game)
    joins(:link).where("links.game_id = ?", game.id)
  end

end
