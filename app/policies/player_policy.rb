class PlayerPolicy < ApplicationPolicy

  def end_turn? 
    user.id == record.user_id && 
    record.can_end_turn?
  end
  
end