class ApiController < ApplicationController
  class ApiError < StandardError
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ApiError, with: :api_error
  
  self.responder = ApiResponder

  private
    def api_error(exception)
      render json: {errors: exception.message}, :status => 400
    end

    def user_not_authorized(exception)
      # Next version of pundit will include access to policy and query in exception 
      # policy_name = exception.policy.class.to_s.underscore
      # error_message = I18n.t "pundit.#{policy_name}.#{exception.query}",
      #   default: 'You cannot perform this action.'

      # For use with I18n eg:
      # en:
      #  pundit:
      #    post_policy:
      #      update?: 'You cannot edit this post!'
      #      create?: 'You cannot create posts!'

      render json: { errors: "You are not authorized to perform this action." }, :status => 403
    end

    def parameter_missing(exception)
      render json: { errors: exception.message }, :status => 400
    end

    def invalid(exception)
      render json: { errors: exception.message }, :status => 400
    end
end
