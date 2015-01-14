class Api::ThingsController < ApiController
  before_filter :find_game, except: [:random, :show]
  respond_to :json

  def index
    if params[:game_id]
      @things = Thing.where(game_id: params[:game_id])
    else
      seed = @game.try(:random_seed) || SecureRandom.random_number(2147483646)
      @things = Thing.not_user_uploaded.random_fixed_order(seed)
    end
    respond_with @things
  end

  def random
    things = Thing.not_user_uploaded.select(:id)
    @thing = Thing.find(things[SecureRandom.random_number(things.length-1)])
    respond_with @thing
  end

  def show
    @thing = Thing.find(params[:id])
  end

  def create
    raise ApiError.new, "Uploaded thing must have associated game" if !@game
    @thing = Thing.new
    @thing.update_attributes(create_thing_params)
    @thing.game = @game
    @thing.creator = current_user
    @thing.updator = current_user

    authorize @thing
    @thing.save
    respond_with @thing
  end

private

  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end

  def create_thing_params
    params.require(:game_id)
    params.require(:thing).permit(
      :title,
      :description,
      :remote_image_url,
      :attribution,
      :access_via,
      :copyright
    )
  end
end
