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
    @game.filter_content_by = clean_search_query_json(game_params[:filter_content_by])
    
    copy_board_to_game
    update_seed_thing if game_params[:seed_thing_id].present? 

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
    @game.filter_content_by = clean_search_query_json(game_params[:filter_content_by])

    copy_board_to_game
    update_seed_thing if game_params[:seed_thing_id].present? 
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
      puts search_query_params.inspect
      puts Search::ThingQuery.new(search_query_params).to_json
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

end
