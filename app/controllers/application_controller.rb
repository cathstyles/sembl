class ApplicationController < ActionController::Base
  # Allows API post calls
  protect_from_forgery with: :null_session

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # decent_configuration do
  #   strategy DecentExposure::StrongParametersStrategy
  # end
  
  private

    def user_not_authorized
      flash[:error] = "You are not authorized to perform this action."
      redirect_to request.headers["Referer"] || root_path
    end

  
end
