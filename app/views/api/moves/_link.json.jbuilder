json.(link, :source_id, :target_id, :round)
json.viewable_resemblance do 
  json.partial! 'api/resemblances/resemblance', resemblance: move.resemblance_for_link(link)
end