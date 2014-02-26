json.(
  @game,
  :id,
  :title,
  :description,
  :invite_only,
  :state,
  :uploads_allowed,
  :theme,
  :allow_keyword_search,
  :current_round,
  :seed_thing_id,
)
json.set! :filter do 
  json.partial! 'search/thing_query', query: @game.filter_query, as: :filter
end

json.board @game.board
json.boards Board.all
json.players @game.players.playing, partial: 'players/player', as: :player
json.nodes @game.nodes, partial: 'nodes/node', as: :node
json.links @game.links, partial: 'links/link', as: :link

json.player do 
  unless @game.player(current_user).nil?
    json.nil!
  else
    json.partial! 'players/player', user: @game.player
  end
end
json.is_participating @game.participating?(current_user)
json.is_hosting @game.hosting?(current_user)
json.errors @game.errors.full_messages
json.auth_token form_authenticity_token
