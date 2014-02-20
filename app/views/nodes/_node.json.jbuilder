json.(node, :id, :round, :x, :y, :state)
json.is_available node.available_to?(current_user)
json.user_state node.user_state(current_user)
json.final_placement  do 
  if node.final_placement.nil? 
    json.nil!
  else 
    json.partial! 'placements/placement', placement: node.final_placement
  end
end
json.player_placement do 
  if node.player_placement(current_user).nil?
    json.nil!
  else
    json.partial! 'placements/placement', placement: node.player_placement(current_user)
  end
end
json.viewable_placement do 
  if node.viewable_placement(current_user).nil? 
    json.nil!
  else 
    json.partial! 'placements/placement', placement: node.viewable_placement(current_user)
  end
end
