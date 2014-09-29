json.(@game, :id,
             :title,
             :description,
             :invite_only,
             :state,
             :uploads_allowed,
             :theme,
             :allow_keyword_search,
             :current_round,
             :seed_thing_id,
             :number_of_players,
)

json.set! :filter do
  json.partial! 'api/search/thing_query', query: @game.filter_query, as: :filter
end

json.board @game.board
json.hostless @game.hostless?

# TODO: Move this into a separate fetch, shouldn't be here.
json.boards Board.all

json.players @game.players.playing, partial: 'api/players/player', as: :player
json.nodes @game.nodes, partial: 'api/nodes/node', as: :node
json.links @game.links, partial: 'api/links/link', as: :link

json.player do
  if @game.player(current_user).nil?
    json.nil!
  else
    json.partial! 'api/players/player', player: @game.player(current_user)
  end
end
json.is_participating @game.participating?(current_user)
json.is_hosting @game.hosting?(current_user)
json.is_admin current_user.admin?
json.errors @game.errors.full_messages
json.auth_token form_authenticity_token
