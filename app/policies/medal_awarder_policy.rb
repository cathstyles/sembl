class MedalAwarderPolicy < ApplicationPolicy

  def awards? 
    (!record.game.invite_only ||
    record.game.participating?(user) ||
    record.game.creator_id == user.try(:id)) && 
    record.game.completed?
  end
end