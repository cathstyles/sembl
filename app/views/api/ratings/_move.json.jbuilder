json.target_node do 
  json.partial! 'api/moves/node', node: move.target_node, placement: move.placement
end
json.links move.links do |json, link|
  json.partial! 'api/moves/link', link: link, move: move, include_rating: true
end
