class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end


  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    false
  end

  def new?
    create?
  end

  # As a default users can update what they have created
  def update?
    user.id == record.creator_id 
  end

  def edit?
    update?
  end

  # As a default users can destroy what they have created
  def destroy?
    user.id == record.creator_id
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end

