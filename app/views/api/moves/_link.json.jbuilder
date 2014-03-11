json.(link, :id, :source_id, :target_id, :round)
json.viewable_resemblance do 
  json.partial! 'api/moves/resemblance', resemblance: move.resemblance_for_link(link)
end