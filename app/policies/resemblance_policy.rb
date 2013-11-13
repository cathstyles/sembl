class ResemblancePolicy < ApplicationPolicy

  def create?
    record.link.available_to?(user)
  end

  def update? 
    user.id == record.creator_id && 
    record.link.game.player(user).state == "completing_turn"
  end

  def destroy?
    update?
  end

  def rate? 
    record.creator_id != user.id &&
    record.link.game.state == "rating" &&  
    record.link.game.participating?(user) 
  end
  
end