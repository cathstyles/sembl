class RegistrationsController < Devise::RegistrationsController
  protected

  # This is called by Devise's registrations contolonly after a successful
  # sign up. We override it here so we can send a welcome email.
  def sign_up(resource_name, resource)
    super

    UserMailer.welcome(resource).deliver
    DeliverEmailJob.enqueue("UserMailer", "welcome", resource.id)
  end

  def after_sign_up_path_for(resource)
    edit_profile_path(new_user: true, for_game: params[:for_game])
  end
end
