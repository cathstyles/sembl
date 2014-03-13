class MovePolicy < ApplicationPolicy

  def create?
    if record.placement.valid?
      record.placement.node.available_to?(user)
    else
      true
    end
  end
end