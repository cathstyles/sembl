json.(node, :id, :round, :x, :y, :state)
json.user_state node.user_state(current_user)
json.viewable_placement do
  if node.viewable_placement(current_user).nil?
    json.nil!
  else
    json.partial! 'api/placements/placement', placement: node.viewable_placement(current_user)
  end
end
