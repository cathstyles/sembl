class TransloaditSignaturesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!

  def template
    attrs = {}

    if Transloadit::Rails::Engine.configuration['templates'].keys.include?(params[:template_id])
      transloadit_params = Transloadit::Rails::Engine.template(params[:template_id])

      transloadit_params = transloadit_params.to_hash.merge(params[:params]) if request.post?

      signature = Transloadit::Rails::Engine.sign(transloadit_params.to_json)

      attrs[:params]    = transloadit_params
      attrs[:signature] = signature
    end

    respond_with attrs, location: nil
  end
end
