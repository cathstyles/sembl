class ApplicationController < ActionController::Base
  # Allows API post calls
  protect_from_forgery with: :null_session

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # decent_configuration do
  #   strategy DecentExposure::StrongParametersStrategy
  # end
  before_filter :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/users/sign_in" &&
        request.fullpath != "/users/sign_up" &&
        request.fullpath != "/users/password" &&
        request.fullpath != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  private

    def user_not_authorized
      puts 'ApplicationController.user_not_authorized'
      if current_user.present?
        flash[:error] = "You are not authorized to perform this action."
        redirect_to request.headers["Referer"] || root_path
      else
        flash[:error] = "Please sign in below<br/>or sign up #{ActionController::Base.helpers.link_to "here", new_user_registration_path}.".html_safe
        redirect_to new_user_session_path
      end
    end
end
