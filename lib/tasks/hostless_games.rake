# Hostless games not updated since this time will be considered stale
STALE_TIME = Time.now

namespace :hostless_games do
  desc "Unpublish any stale hostless games and create hostless games for each board type"
  task update: [:environment] do
    unpublish_stale_hostless_games
    existing_open_hostless_boards = Game.open_to_join.hostless.map(&:board)
    boards_without_open_hostless_games = Board.all - existing_open_hostless_boards
    boards_without_open_hostless_games.each do |board|
      create_hostless_game_from board
    end
  end
end

def unpublish_stale_hostless_games
  Game.hostless.where("updated_at < ?", STALE_TIME).map(&:unpublish)
end

def create_hostless_game_from(board)
  game = Game.new board: board, title: "#{board.title} - #{Time.now}", seed_thing_id: Thing.last.id, state: "draft"
  game.copy_nodes_and_links_from_board
  update_seed_thing(game, Thing.all.sample)
  game.state = "open"
  game.save!
end

# this method was copied from app/controllers/api/games_controller
def update_seed_thing(game, thing)
  if seed_thing = thing
    seed_node = game.nodes.detect {|node|
      node.round == 0 && !node.marked_for_destruction?
    }
    return unless seed_node
    placement = seed_node.placements[0] || seed_node.placements.build
    placement.assign_attributes(
      thing: seed_thing
    )
  end
end


