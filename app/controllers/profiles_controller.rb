class ProfilesController < ApplicationController
  respond_to :html

  before_filter :find_profile

  def edit    
    authorize @profile
    respond_with @profile
  end

  def update
    authorize @profile

    @profile.assign_attributes(profile_params)
    
    flash[:notice] = "Profile updated." if @profile.save

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
      :remote_avatar_url
    )
  end

end
