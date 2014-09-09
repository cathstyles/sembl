class Admin::UsersController < AdminController
  respond_to :html

  def index
    @users = User.order("updated_at DESC")
    respond_with :admin, @users
  end

  def new
    @user = User.new
    respond_with :admin, @user
  end

  def create
    @user = User.new(user_params)
    @user.save
    respond_with :admin, @user, location: [:admin, :users]
  end

  def edit
    @user = User.find(params[:id])
    @games_hosted_by_user = Game.hosted_by(@user)
    respond_with :admin, @user
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    @user.save
    respond_with :admin, @user, location: [:admin, :users]
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_with :admin, @user, location: [:admin, :users]
  end

protected

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role).
      delete_if { |key, value| key.in? %w(password password_confirmation) and value.blank? }
  end
end
