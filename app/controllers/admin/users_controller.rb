class Admin::UsersController < AdminController
  expose(:users)
  expose(:user, attributes: :user_params)

  respond_to :html

  def index
    respond_with :admin, users
  end

  def new
    respond_with :admin, user
  end

  def create
    user.save

    respond_with :admin, user, location: [:admin, :users]
  end

  def edit
    respond_with :admin, user
  end

  def update
    user.save

    respond_with :admin, user, location: [:admin, :users]
  end

  def destroy
    user.destroy

    respond_with :admin, user, location: [:admin, :users]
  end

protected

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation).
      delete_if { |key, value| key.in? %w(password password_confirmation) and value.blank? }
  end
end
