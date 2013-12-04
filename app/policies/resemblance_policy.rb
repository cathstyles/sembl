class ResemblancePolicy < ApplicationPolicy

  def create?
    record.link.available_to?(user)
  end

  def update? 
    user.id == record.creator_id && 
    record.link.game.player(user).playing_turn?
  end

  def destroy?
    update?
  end

  def rate? 
    record.creator_id != user.id &&
    record.game.rating? &&  
    record.game.participating?(user) 
  end
  
end
