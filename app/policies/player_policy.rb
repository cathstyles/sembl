class PlayerPolicy < ApplicationPolicy

  def end_turn? 
    user.id == record.user_id && 
    record.state == "completing_turn" && 
    record.can_end_turn?
  end
  
end