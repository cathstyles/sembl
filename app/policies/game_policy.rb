class GamePolicy < ApplicationPolicy
  def index? 
    true
  end

  def show?
    !record.invite_only ||
    record.participating?(user) ||
    record.creator_id == user.id 
  end

  def create?
    user.exists?
  end

  def update?
    user.id == record.creator_id && record.editable?
  end

  def destroy?
    user.id == record.creator_id && record.editable?
  end

  def summary?
    show?
  end

  def join? 
    record.state == "open"
    #scope.open_to_join.where(:id => record.id).exists?
  end
end