json.(
  game,
  :id,
  :title,
  :description,
  :invite_only,
  :state,
  :uploads_allowed,
  :theme,
  :allow_keyword_search,
  :current_round
)

json.players @game.players.playing, partial: 'players/player', as: :player
json.nodes @game.nodes, partial: 'nodes/node', as: :node
json.links @game.links, partial: 'links/link', as: :link

json.is_participating @game.participating?(current_user)
json.is_hosting @game.hosting?(current_user)
json.errors @game.errors.full_messages
json.auth_token form_authenticity_token
