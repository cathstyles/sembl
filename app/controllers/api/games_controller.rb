class Api::GamesController < ApiController
  respond_to :json

  after_filter :verify_authorized

  before_filter :authenticate_user!, except: [:show]
  before_filter :find_game, except: [:new, :create]

  def show
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

  def end_turn
    authorize @game
    player = @game.player(current_user)
    player.end_turn if player
    @game.reload
    respond_with @game
  end

  def end_rating
    authorize @game
    player = @game.player(current_user)

    # State transition callbacks handle:
    # * Check whether all players are in waiting state now
    # * For each placement calculate the score as average of all sembl ratings
    # * Reify winning placement
    # * Transition game to next round or end of game.

    player.end_rating if player
    @game.reload
    respond_with @game
  end

  # End turn for all players
  def end_round
    authorize @game
    if @game.state != "playing" || !@game.has_placements_for_round?
      raise ApiError.new(params), "Cannot end the round."
    else

      @game.players.each do |player|
        player.force_end_turn if player && player.state == "playing_turn"
      end
      @game.reload
      respond_with @game
    end
  end

  # End rating for all players
  def end_round_rating
    authorize @game

    if @game.state != "rating" || !@game.has_ratings_for_round?
      raise ApiError.new(params), "Cannot end the rating round."
    else

      @game.players.each do |player|
        user = player.user
        # End all the ratings
        placements = Placement.for_round(@game).where('creator_id != ?', user.id)
        moves = placements.collect{|p| Move.new(placement: p)}.shuffle

        if moves.present?
          moves.each do |move|
            if move.links.present?
              move.links.each do |link|
                sembl = link.viewable_resemblance(user)
                if sembl.present? && !sembl.rating_by(user).present?
                  rating = Rating.new(resemblance: sembl, creator: user)
                  rating.assign_attributes(rating: 50)
                  rating.save
                end
              end
            end
          end
        end

        player.end_rating if player && player.state == "rating"
      end

      # Just manually check for completion
      @game.players.first.check_rating_completion

      @game.reload
      respond_with @game
    end
  end

  def create
    puts 'creating with', params.inspect
    puts 'creating with', game_params.inspect
    # Auto assign a random seed if none exists
    if params[:game][:seed_thing_id].blank?
      params[:game][:seed_thing_id] = random_thing_seed
    end
    @game = Game.new(game_params)
    @game.creator = current_user
    @game.updator = current_user
    @game.state_event = 'publish' if params[:publish]
    @game.filter_content_by = clean_search_query_json(params[:game][:filter_content_by])

    @game.copy_nodes_and_links_from_board
    update_seed_thing if game_params[:seed_thing_id].present?

    authorize @game
    if @game.save
      @game.crop_board
    end
    respond_with @game
  end

  def update
    puts 'updating with', params.inspect
    puts 'updating with', game_params.inspect
    @game.assign_attributes(game_params)
    @game.updator = current_user
    @game.state_event = 'publish' if params[:publish]
    @game.filter_content_by = clean_search_query_json(params[:game][:filter_content_by])

    @game.copy_nodes_and_links_from_board
    update_seed_thing if game_params[:seed_thing_id].present?

    authorize @game
    @game.save
    respond_with @game
  end

  def destroy
    raise ApiError.new(params), 'Game not found' unless !!@game
    authorize @game
    @game.delete
    message = "Game successfully deleted"
    flash[:notice] = message
    render json: {message: message}
  end

private

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
    @game.crop_board
  end

  def clean_search_query_json(search_query_params)
    if search_query_params
      clean_query_params = search_query_params.delete_if do |k,v|
        v.strip.empty?
      end.symbolize_keys
      cleaned_json = ThingSearch.new(clean_query_params).to_json
      cleaned_json
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
      :theme,
      :allow_keyword_search,
      :seed_thing_id,
      players_attributes: [:id, :email, :user_id, :_destroy]
    )
  end

  def random_thing_seed
    things = Thing.not_user_uploaded.select(:id)
    Thing.find(things[SecureRandom.random_number(things.length-1)]).id
  end
end
