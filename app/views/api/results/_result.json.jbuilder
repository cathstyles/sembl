json.user { json.partial! 'api/users/user', user: move.user } if move.user.present?
json.score move.placement.score
json.target do
  json.node(move.target_node, :id, :round)
  json.thing { json.partial! 'api/things/thing', thing: move.placement.thing}
end
json.resemblances do
  json.array! move.resemblances do |resemblance|
    json.(resemblance, :id, :score, :description, :source_description, :target_description)
    json.target_state move.placement.state
    json.source do
      json.node(resemblance.source.node, :id, :round)
      json.thing { json.partial! 'api/things/thing', thing: resemblance.source.thing}
    end
  end
end
