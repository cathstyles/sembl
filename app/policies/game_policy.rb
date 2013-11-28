class GamePolicy < ApplicationPolicy
  def index? 
    true
  end

  def show?
    !record.invite_only ||
    record.participating?(user) ||
    record.creator_id == user.try(:id) 
  end

  def create?
    !!user
  end

  def update?
    !!user && user.id == record.creator_id && record.editable?
  end

  def destroy?
    !!user && user.id == record.creator_id && record.editable?
  end

  def summary?
    show?
  end

  def join? 
    !!user && record.state == "open"
    #scope.open_to_join.where(:id => record.id).exists?
  end
end