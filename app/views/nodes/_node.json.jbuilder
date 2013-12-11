json.(node, :id, :round, :x, :y, :state)
json.is_available node.available_to?(current_user)
json.user_state node.user_state(current_user)
json.final_placement  do 
  json.partial! 'placements/placement', placement: node.final_placement
end
json.player_placement do 
  json.partial! 'placements/placement', placement: node.player_placement(current_user)
end
