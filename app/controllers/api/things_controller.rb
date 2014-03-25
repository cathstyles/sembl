class Api::ThingsController < ApiController
  before_filter :find_game, except: [:random, :show]
  respond_to :json

  def index
    seed = @game.try(:random_seed) || SecureRandom.random_number(2147483646)
    @things = Thing.all.random_fixed_order(seed)
    respond_with @things
  end

  def random
    things = Thing.all.select(:id)
    @thing = Thing.find(things[SecureRandom.random_number(things.length-1)])
    respond_with @thing
  end

  def show
    @thing = Thing.find(params[:id])
  end

private

  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end
end
