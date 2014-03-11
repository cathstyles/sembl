json.(link, :id, :source_id, :target_id, :round)
json.viewable_resemblance do 
  if link.viewable_resemblance(current_user).nil?
    json.nil!
  else 
    json.partial! 'api/resemblances/resemblance', resemblance: link.viewable_resemblance(current_user)
  end
end