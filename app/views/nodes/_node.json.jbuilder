json.(node, :id, :round, :x, :y, :state)
json.is_available node.available_to?(current_user)
json.user_state node.user_state(current_user)
json.final_placement node.final_placement, partial: 'placements/placement', as: :placement
json.player_placement node.player_placement(current_user), partial: 'placements/placement', as: :placement