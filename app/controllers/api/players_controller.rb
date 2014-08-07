class Api::PlayersController < ApiController
  respond_to :json

  after_filter :verify_authorized, except: [:show]

  before_filter :authenticate_user!
  before_filter :find_game

  def index
    @players = @game.players
    authorize @game
    respond_with @players
  end

  def show
    @player = @game.players.find(params[:id])
    authorize @player
    respond_with @player
  end

  def create
    raise ApiError.new(params), 'Game not found' unless !!@game

    if @game.number_of_players <= @game.players.length
      raise ApiError.new(params), 'Too many players'
    end

    email = player_params[:email]

    @player = Player.new(email: email)
    @player.game = @game

    user =  User.find_by_email(player_params[:email])
    @player.user = user unless !user

    authorize @player
    @player.save!
    respond_with json: @player
  end

  def destroy
    raise ApiError.new(params), 'Game not found' unless !!@game
    @player = @game.players.find_by_id(params[:id])
    raise ApiError.new(params), 'Player not found' unless !!@player
    authorize @player
    @player.delete
    render json: {message: "Player removed"}
  end

  private
  def find_game
    @game = Game.find(params[:game_id]) if params[:game_id]
  end

  def player_params
    params.require(:player).permit(:email)
  end
end
