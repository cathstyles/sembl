class ThingPolicy < ApplicationPolicy
  def create?
    !!record.game
    # record.resemblance.creator_id != user.id &&
    # record.resemblance.link.game.participating?(user) 
    true
  end
end
