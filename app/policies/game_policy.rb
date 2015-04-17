class GamePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.completed? ||
    !record.invite_only ||
    record.participating?(user) ||
    record.creator_id == user.try(:id) ||
    (user && user.admin?) #TODO: change this when we go live
  end

  def create?
    !!user
  end

  def update?
    !!user && (user.id == record.creator_id || user.admin?)
  end

  def destroy?
    !!user && (user.id == record.creator_id || user.admin?)
  end

  def join?
    !!user && record.open_to_join?
  end

  def end_turn?
    record.participating?(user) &&
    record.player(user).can_end_turn?
  end

  def end_rating?
    record.participating?(user) &&
    record.player(user).can_end_rating?
    # true
  end

  def summary?
    show?
  end

  def customise?
    create? && (user.power_user? || user.admin?)
  end

  def save_template?
    customise?
  end
end
