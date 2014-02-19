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
    !!user && user.id == record.creator_id 
  end

  def destroy?
    !!user && user.id == record.creator_id && record.draft?
  end

  # Host cannot join a game
  def join?
    !!user && record.open_to_join? && record.creator_id != user.id
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