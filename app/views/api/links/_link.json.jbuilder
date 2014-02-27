json.(link, :source_id, :target_id, :round)
json.final_resemblance  do 
  if link.final_resemblance.nil?
    json.nil!
  else 
    json.partial! 'api/resemblances/resemblance', resemblance: link.final_resemblance
  end
end
json.player_resemblance do 
  if link.player_resemblance(current_user).nil?
    json.nil!
  else
    json.partial! 'api/resemblances/resemblance', resemblance: link.player_resemblance(current_user)
  end
end
json.viewable_resemblance do 
  if link.viewable_resemblance(current_user).nil?
    json.nil!
  else 
    json.partial! 'api/resemblances/resemblance', resemblance: link.viewable_resemblance(current_user)
  end
end