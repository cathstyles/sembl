json.(node, :id, :round, :x, :y, :state)
json.is_available node.available_to?(current_user)
json.final_placement node.final_placement, partial: 'placements/placement', as: :placement