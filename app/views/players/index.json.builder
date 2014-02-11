json.array! @players do |player|
  json.partial! 'players/player', player: player
end

