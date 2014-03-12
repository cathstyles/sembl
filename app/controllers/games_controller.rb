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

  # Copy nodes and links from board
  def copy_board_to_game
    board = @game.board
    return unless @game.board_id.present? && @game.board_id_changed? 

    # So they are not destroyed if validation fails.
    @game.nodes.each {|n| n.mark_for_destruction }
    @game.links.each {|l| l.mark_for_destruction }

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

  def update_seed_thing
    if  seed_thing = Thing.find(game_params[:seed_thing_id])
      seed_node = @game.nodes.detect {|node| 
        node.round == 0 && !node.marked_for_destruction? 
      }
      return unless seed_node

      placement = seed_node.placements[0] || seed_node.placements.build
      placement.assign_attributes(
        thing: seed_thing,
        creator: current_user
      )
      
    end
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def clean_search_query_json(search_query_json)
    puts search_query_json
    if search_query_json and not search_query_json.empty?
      search_query_params = JSON.parse(search_query_json, symbolize_names: true)
      Search::ThingQuery.new(search_query_params).to_json
    else
      nil
    end
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

  def tmp_game_params
    params.require(:tmpgame).permit(
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
