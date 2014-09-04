# Hostless games that have players and have not been updated since this time and will be considered stale
JOINED_STALE_TIME =   ENV["JOINED_STALE_TIME"] || 1.hour.ago
UNJOINED_STALE_TIME = ENV["UNJOINED_STALE_TIME"] || 1.day.ago

namespace :hostless_games do
  desc "Unpublish any stale hostless games and create hostless games for each board type"
  task update: [:environment] do
    mark_old_hostless_games_with_players_as_stale
    mark_old_hostless_games_without_players_as_stale
    existing_open_hostless_boards = Game.open_to_join.not_stale.hostless.map(&:board)
    boards_without_open_hostless_games = Board.all - existing_open_hostless_boards
    boards_without_open_hostless_games.each do |board|
      create_hostless_game_from board
    end
  end
end

def mark_old_hostless_games_with_players_as_stale
  Game.hostless.where("updated_at < ?", JOINED_STALE_TIME).each do |game|
    game.update_attribute(:stale, true) if game.players.count > 0
  end
end

def mark_old_hostless_games_without_players_as_stale
  Game.hostless.where("updated_at < ?", UNJOINED_STALE_TIME).each do |game|
    game.update_attribute(:stale, true)
  end
end

def create_hostless_game_from(board)
  seed_thing = Thing.where("title is not null").sample
  game = Game.new(board: board,
    title: "#{seed_thing.title}",
    description: "A game for #{board.number_of_players} #{'player'.pluralize(board.number_of_players)}, starting with:",
    seed_thing_id: Thing.last.id,
    state: "draft")
  game.copy_nodes_and_links_from_board
  update_seed_thing(game, seed_thing)
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


