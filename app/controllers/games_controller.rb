class GamesController < ApplicationController
  respond_to :html

  after_filter :verify_authorized, :except => :index

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :find_game, except: [:index, :new, :create]

  def index
    # begin rescue because this action often causes us to go over
    # the hobby db connection limit of 20 on postgres...
    begin
      @games = filtered_games.page(params[:page])
      @filter = filter_scope
      respond_with @games
    rescue ActiveRecord::StatementInvalid => e
      ActiveRecord::Base.connection.reconnect!
    end
  end

  def show
    authorize @game
    respond_with @game, layout: "react"
  end

  def new
    @game = Game.new
    authorize @game
    respond_with @game, layout: "react"
  end

  def edit
    authorize @game
    respond_with @game, layout: "react"
  end

  def destroy
    @game.authorize
    flash[:notice] = 'Game deleted.' if @game.destroy
    respond_with @game
  end

private

  def find_game
    @game = Game.find(params[:id])
    @game.crop_board
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

  def filter_scope
    if params[:filter].blank? && current_user
      :participating
    elsif params[:filter].present?
      params[:filter].to_sym
    else
      :open
    end
  end

  def filtered_games
    case filter_scope
    when :participating
      Game.participating(current_user).without_states(:completed)
    when :hosted
      Game.hosted_by(current_user)
    when :browse
      Game.where(invite_only: false).without_states(:open, :joining, :completed)
    when :completed
      Game.where(invite_only: false).with_states(:completed)
    when :user_completed
      Game.participating(current_user).with_states(:completed)
    else
      Game.open_to_join.not_stale
    end
  end

end
