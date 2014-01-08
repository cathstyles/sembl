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
    # Skip to playing turn, no need for invitation workflow.
    @game.players.build(user: current_user, state: 'playing_turn')
    @game.join if @game.save
    respond_with @game
  end

  def create
    @game = Game.new(game_params)
    @game.creator = current_user
    @game.updator = current_user
    @game.state_event = 'publish' if params[:publish]

    copy_board_to_game
    add_or_update_seed_thing

    authorize @game

    if @game.save
      flash[:notice] = 'Game created.' if @game.save
      redirect_to games_path
    else
      respond_with(@game)
    end
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
    @game.updator = current_user
    @game.state_event = 'publish' if params[:publish]

    copy_board_to_game
    add_or_update_seed_thing
    authorize @game
    
    if @game.save
      flash[:notice] = 'Game saved.' if @game.save
      redirect_to games_path
    else
      respond_with(@game)
    end
  end

  def destroy
    @game.authorize
    flash[:notice] = 'Game deleted.' if @game.destroy
    respond_with @game
  end

private

  # Copy nodes and links from board
  def copy_board_to_game
    board = @game.board
    return unless board.present? 

    @game.nodes.destroy_all
    @game.links.destroy_all

    node_array = []
    board.nodes_attributes.each do |node_attr|
      node_array << @game.nodes.build(node_attr.except('fixed'))
    end

    board.links_attributes.each do |link_attr| 
      @game.links.build(
        source: node_array[link_attr['source']],
        target: node_array[link_attr['target']]
      )
    end

    @game.number_of_players = board.number_of_players
  end

  def add_or_update_seed_thing
    if seed_thing = Thing.find(game_params[:seed_thing_id])
      seed_node = @game.nodes.detect {|node| node.round == 0 }
      return unless seed_node

      if placement = seed_node.placements.take
        placement.assign_attributes(
          thing: seed_thing, 
          creator: current_user
        )
      else
        seed_node.placements.build(
          thing: seed_thing, 
          creator: current_user
        ) 
       
      end
    end
  end

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
