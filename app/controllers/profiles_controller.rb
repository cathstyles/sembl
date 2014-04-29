class ProfilesController < ApplicationController
  respond_to :html

  before_filter :find_profile

  def edit    
    authorize @profile
    respond_with @profile
  end

  def update
    authorize @profile

    params_copy = profile_params
    params_copy[:user_attributes] = params_copy[:user_attributes].delete_if { |key, value| key.in? %w(password password_confirmation) and value.blank? }

    @profile.assign_attributes(params_copy)
    
    if @profile.save
      flash[:notice] = "Profile updated." if @profile.save
      # updating a user in device signs them out by default.
      sign_in(@profile.user, :bypass => true)
    end

    respond_with @profile, location: root_path
  end

  private

  def find_profile
    @profile = Profile.where(user: current_user).take
  end 

  def profile_params 
    params.require(:profile).permit(
      :name, 
      :bio, 
      :remote_avatar_url, 
      user_attributes: [:id, :email, :password, :password_confirmation]
    )
  end

end
