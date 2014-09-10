class Admin::GamesController < AdminController
  respond_to :html

  def index
    @games = Game.order("updated_at DESC")
    respond_with :admin, @games
  end

  def edit
    @game = Game.find(params[:id])
    respond_with :admin, @game
  end

  def update
    @game = Game.find(params[:id])
    @game.update_attributes(game_params)
    @game.save
    respond_with :game, @game, location: [:admin, :games]
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_with :admin, @game, location: [:admin, :games]
  end

  protected

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
