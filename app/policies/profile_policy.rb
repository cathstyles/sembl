class ProfilePolicy < ApplicationPolicy

  def edit?
    !!user && record.user == user
  end

  def update? 
    !!user && record.user == user
  end
  
end