class GamesController < ApplicationController
  respond_to :html

  def edit

  end

  private

  def profile_params 

    params.require(:profile).permit(
      :name, 
      :bio,
      :avatar
    )
  end

end
