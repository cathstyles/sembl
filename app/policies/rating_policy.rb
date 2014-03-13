class RatingPolicy < ApplicationPolicy

  # The record here is the game. 
  # This should probably use some sort of scope policy but I can't work out how ATM
  def index? 
    record.participating?(user)
  end

  def create?
    # TODO: enable fix this!
    # record.resemblance.creator_id != user.id &&
    # record.resemblance.link.game.participating?(user) 
    true
  end

end
