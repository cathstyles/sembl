class ContributionsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_thing, only: [:show, :edit, :update, :destroy]

  respond_to :html
  respond_to :json

  # GET /contributions
  def index
    @things = current_user.created_things
    respond_with @things
  end

  # GET /contributions/:id
  def show
    respond_with @thing
  end

  # GET /contributions/new
  def new
    @thing = current_user.created_things.new
    respond_with @thing
  end

  # GET /contributions/:id/edit
  def show
    respond_with @thing
  end

  # POST /contributions
  def create
    @thing = current_user.created_things.build(thing_params)
    @thing.save
    respond_with @thing, location: contribution_path(@thing)
  end

  # PATCH /contributions/:id
  def update
    @thing.update thing_params
    respond_with @thing, location: contribution_path(@thing)
  end

  # DELETE /contributions/:id
  def destroy
    @thing.destroy
    respond_with @thing
  end

  private

  def set_thing
    @thing = current_user.created_things.find(params[:id])
  end

  def thing_params
    params.require(:thing).permit(:title, :description, :image, :attribution, :item_url, :copyright, :import_row_id, :access_via)
  end
end
