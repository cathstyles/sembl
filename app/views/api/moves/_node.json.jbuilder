json.(node, :id, :round, :x, :y, :state)
json.viewable_placement do 
  json.partial! 'api/placements/placement', placement: placement
end