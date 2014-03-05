class Api::MovesController < ApplicationController
  respond_to :json

  before_filter :authenticate_user!
  before_filter :find_game, only: [:round]

  # TODO remove once we turn this back into a post in react.
  def index
    create
  end

  # List of moves to rate. 
  # for_round defaults to current round
  def round
    placements = Placement.for_round(@game)
    @moves = placements.collect{|p| Move.new(placement: p)}
    respond_with @moves
  end

  #TODO is this being used?
  def show
    @node = Node.find(params[:id])
    respond_with @node
  end

  def create
    move_params

    game = Game.find(move_params.game_id)

    # target_params = move_params[:target]
    # target_placement = Placement.new(
    #   creator: current_user, 
    #   node: Node.find(target_params[:node_id]), 
    #   thing: Thing.find(target_params[:thing_id])
    # )

    move = Move.new(user: current_user)
    move.placement = move_params[:target]
    move.resemblances = move_params[:resemblances]
    if move.save
      @result = result(status=:ok, notice='Move created')
      game.player(current_user).move_created
      respond_with @result
    else
      @result = result(status=:fail, alert='Move could not be created', errors=move.errors.full_messages)
      respond_with @result
    end

    # resemblances = []
    # move_params[:resemblances].each do |resemblance_params|
    #   source_params = resemblance_params[:source]
    #   source_placement = Placement.find_by(
    #     node_id: source_params[:node_id],
    #     thing_id: source_params[:thing_id]
    #   )
    #   Link.find_by(
    #     source_id: source_placement.node.id,
    #     target_id: target_placement.node.id,
    #     game_id: game.id 
    #   )
    #   resemblances << Resemblance.new(
    #     link: link,
    #     description: resemblance_params[:description],
    #     creator: current_user
    #   )
    # end

    # error_record = nil
    # ActiveRecord::Base.transaction do
    #   error_record = target_placement unless target_placement.save
    #   resemblances.each do |sembl|
    #     error_record = sembl unless sembl.save
    #   end
    # end

    # if !error_record
    #   @result = result(status=:ok, notice='Move created')
    #   game.player(current_user).move_created
    #   respond_with @result
    # else
    #   @result = result(status=:fail, alert='Move could not be created', errors=error_record.errors.full_messages)
    #   respond_with @result
    # end
  end

  private

  def result(status=nil, notice=nil, alert=nil, errors=nil)
    {
      status: status,
      notice: notice,
      alert:  alert,
      errors: errors
    }
  end

  def move_params
    move = params.require(:move)
    move.require(:game_id)

    target = move.require(:target)
    target.require(:node_id)
    target.require(:thing_id)

    resemblances = move.require(:resemblances)
    resemblances.require(:description)
    source = resemblances.require(:source)
    source.require(:node_id)
    source.require(:thing_id)

    move
  end

  def find_game
    @game = Game.find(params[:game_id])
  end

end
