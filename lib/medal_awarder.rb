# Awards medals based on game results

class MedalAwarder

  # who won overall (and how many nodes they won, and their average sembl rating)
  # whose sembl was highest-rated (and what it was)
  # who was the highest rater (and their average rating)
  # who was the lowest rater (and their average rating)

  # TODO: Going to leave this for now, I don't think we want to encourage wordy sembls do we? 
  # who made the wordiest sembl (and what it was)

  def initialize(game)
    @game = game
    @resemblances = Resemblance.for_game(@game)
    # @placements = Placement.for_game(@game)
    @ratings = Rating.for_game(@game)
    @average_player_ratings = @ratings.group("ratings.creator_id").average(:rating)
  end

  def winner
    player = @game.players.order("score DESC").limit(1).take
    nodes_won = @game.nodes.select{|node| node.final_placement.creator == player.user}.count

    {
      player: player, 
      nodes_won: nodes_won
    }
  end

  # TODO: This should probably be highest rated move. 
  # In my example game I got a sembl that didn't win a placement because 
  # the other sembls in the move were rated lower. 
  def highest_rated_sembl 
    sembl = @resemblances.order("score DESC").limit(1).take
    {
      player: @game.player(sembl.creator), 
      sembl: sembl
    }
  end

  def highest_rater
    rater = @average_player_ratings.max_by { |k, v| v }
    {
      player: @game.player(User.find(rater[0])), 
      rating: rater[1].to_f
    }
  end

  def lowest_rater
    rater = @average_player_ratings.min_by { |k, v| v }
    {
      player: @game.player(User.find(rater[0])), 
      rating: rater[1].to_f
    }
  end
end