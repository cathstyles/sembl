class PlayerPolicy < ApplicationPolicy

  def end_turn? 
    user.id == record.user_id && 
    record.can_end_turn?
  end

  def create?
    !!user && && record.game.open_to_join?
  end
  
end