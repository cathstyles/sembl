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
    !!user && user.id == record.creator_id && record.configurable?
  end

  def destroy?
    !!user && user.id == record.creator_id && record.draft?
  end

  def summary?
    show?
  end

  def customise? 
    create? && (user.power? || user.admin?)
  end

  def save_template? 
    customise?
  end
end