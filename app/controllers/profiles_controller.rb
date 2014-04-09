class ProfilesController < ApplicationController
  respond_to :html

  def edit

  end

  def process_avatar
  end

  private

  def profile_params 

    params.require(:profile).permit(
      :name, 
      :bio
    )
  end

end
