class GamesController < ApplicationController
  respond_to :html

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
    @game.crop_board
    respond_with @game, layout: "react"
  end

  # TODO: Move these into Backbone routes.
  def new
    @game = Game.new
    authorize @game
    respond_with @game
  end

  def edit
    authorize @game
    respond_with @game
  end

  def destroy
    @game.authorize
    flash[:notice] = 'Game deleted.' if @game.destroy
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
      :allow_keyword_search,
      :seed_thing_id,
      players_attributes: [:id, :email, :user_id, :_destroy]
    )
  end


end
