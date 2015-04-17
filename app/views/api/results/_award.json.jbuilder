json.(award, :name, :icon, :result_name, :result)

json.player do
  json.partial! 'api/players/player', player: award[:player]
end

# json.result do
#   if false #award[:result].class == Resemblance
#     # TODO: new resemblance partial to show target and source nodes?
#     json.partial! 'api/resemblances/resemblance', resemblance: award[:result]
#   else
#     award[:result]
#   end
# end
