# Hostless games that have players and have not been updated since this time and will be considered stale
HOSTLESS_UNJOINED_STALE_TIME = ENV["HOSTLESS_UNJOINED_STALE_TIME"].to_i || (60 * 60 * 24)

HOSTLESS_JOINED_STALE_TIMES = [
  { players: 2, hours: 3 },
  { players: 3, hours: 6 },
  { players: 4, hours: 12 },
  { players: 5, hours: 24 },
  { players: 6, hours: 48 },
  { players: 7, hours: 24 * 3 },
  { players: 8, hours: 24 * 6 },
  { players: 9, hours: 24 * 9 },
  { players: 10, hours: 24 * 12 },
  { players: 11, hours: 24 * 24 },
  { players: 12, hours: 24 * 30 }
]

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
  Game.hostless.where(stale: false).where("number_of_players > 0").each do |game|
    game.update_attribute(:stale, true) if game.updated_at < joined_expiry_time_for_game(game)
  end
end

def mark_old_hostless_games_without_players_as_stale
  unjoined_expiry_time = Time.now - HOSTLESS_UNJOINED_STALE_TIME
  Game.hostless.where("updated_at < ?", unjoined_expiry_time).each do |game|
    game.update_attribute(:stale, true) if game.players.count == 0
  end
end

def create_hostless_game_from(board)
  seed_thing = Thing.not_user_uploaded.where("title is not null").sample
  game = Game.new(board: board,
    title: seed_thing.title,
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

def joined_expiry_time_for_game(game)
  return Time.now unless game.board.present?
  expiry_in_hours = HOSTLESS_JOINED_STALE_TIMES.find { |t| t[:players] == game.board.try(:number_of_players) }[:hours] || 3
  Time.now - (expiry_in_hours * 60 * 60)
end


