class Admin::ThingsController < AdminController
  respond_to :html

  def index
    @things = Thing.order("updated_at DESC")
    respond_with :admin, @things
  end

  def new
    @thing = Thing.new
    respond_with :admin, @thing
  end

  def create
    @thing = Thing.new(thing_params)
    @thing.creator = current_user
    @thing.save
    respond_with :admin, @thing, location: [:admin, :things]
  end

  def edit
    @thing = Thing.find(params[:id])
    respond_with :admin, @thing
  end

  def update
    @thing = Thing.find(params[:id])
    @thing.update_attributes(thing_params)
    @thing.updator = current_user
    @thing.save
    respond_with :admin, @thing, location: [:admin, :things]
  end

  def destroy
    @thing = Thing.find(params[:id])
    @thing.destroy
    respond_with :admin, @thing, location: [:admin, :things]
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
      :access_via,
      :moderated
    )
  end
end
