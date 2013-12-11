class Admin::ThingsController < AdminController
  expose(:things)
  expose(:thing, attributes: :thing_params)

  respond_to :html

  def index
    respond_with :admin, things
  end

  def new
    respond_with :admin, thing
  end

  def create
    thing.creator = current_user
    thing.save

    respond_with :admin, thing, location: [:admin, :things]
  end

  def edit
    respond_with :admin, thing
  end

  def update
    thing.updator = current_user
    thing.save

    respond_with :admin, thing, location: [:admin, :things]
  end

  def destroy
    thing.destroy

    respond_with :admin, thing, location: [:admin, :things]
  end

protected

  def thing_params
    params.require(:thing).permit(
      :title, 
      :description, 
      :image,
      :suggested_seed, 
      :attribution,
      :copyright,
      :general_attributes, 
      :access_via
    )
  end
end
