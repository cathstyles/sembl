class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    edit_profile_path(:new_user => true)
  end
end
