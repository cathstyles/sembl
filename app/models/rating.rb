class Rating < ActiveRecord::Base
  belongs_to :resemblance
  belongs_to :creator, class_name: "User"

  validate :cannot_belong_to_creator
  after_create :update_resemblance_score
  after_save :update_resemblance_score

  def cannot_belong_to_creator
    if creator == resemblance.creator
      errors.add(:base, "You cannot rate your own sembl.")
    end
  end

  def update_resemblance_score 
    resemblance.calculate_score
    resemblance.save! 
  end

  def self.for_game(game)
    joins(:resemblance => :link).where("links.game_id = ?", game.id)
  end
end
