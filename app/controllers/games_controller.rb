class GamesController < ApplicationController
  respond_to :html, :json

  after_filter :verify_authorized, :except => :index

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game, except: [:index, :new, :create]

  def index
    @games = {
      open: Game.open_to_join,
      participating:  Game.participating(current_user),
      hosted: Game.hosted_by(current_user)
    }

    respond_with @games
  end

  def show
    authorize @game
    respond_with @game
  end

  def summary
    authorize @game
    respond_with @game
  end

  def join
    authorize @game
    @game.players.build(user: current_user)
    @game.join if @game.save
    respond_with @game
  end

  def create
    @game = Game.new(game_params)
    @game.copy_board_to_game
    authorize @game

    flash[:notice] = 'Game created.' if @game.save
    respond_with(@game)
  end

  def new
    @game = Game.new
    authorize @game
    respond_with @game
  end

  def edit
    authorize @game
    respond_with @game
  end

  def update
    @game.assign_attributes(game_params)

    authorize @game
    flash[:notice] = 'Game saved.' if @game.save
    respond_with @game
  end

private

  def find_game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(
      :board_id, 
      :title, 
      :description, 
      :invite_only, 
      :uploads_allowed,
      :filter_content_by, 
      :theme, 
      :allow_keyword_search
    )
  end
end
