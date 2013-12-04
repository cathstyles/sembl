class PlacementPolicy < ApplicationPolicy

  def create?
    record.node.available_to?(user)
  end

  def update? 
    user.try(:id) == record.creator_id && 
    record.node.game.player(user).playing_turn?
  end

  def destroy?
    update?
  end
  
end