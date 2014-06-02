class SessionsController < Devise::SessionsController
  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.banned?
      flash[:notice] = "You have been banned from this site. Please contact the site administrator."
      sign_out(resource)
      redirect_to root_path
    else
      set_flash_message(:notice, :signed_in) if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
end
