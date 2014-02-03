class ContributionsController < ApplicationController
  respond_to :html

  # GET /contributions
  def index
    @things = Thing.all
  end

  # GET /contributions/1
  def show
    @thing = Thing.find(params[:id])
  end

  # GET /contributions/new
  def new
    @thing = Thing.new
  end

  # POST /contributions
  def create
    @thing = Thing.new(thing_params)

    if @thing.save
      redirect_to contribution_path(@thing), notice: 'Thing was successfully created.'
    else
      render action: 'new'
    end
  end

  private

  def thing_params
    params.require(:thing).permit(:title, :description, :image, :attribution, :item_url, :copyright, :import_row_id, :access_via)
  end
end
