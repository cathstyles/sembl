json.array! (
  json.results @moves do |json, move|
    json.partial! 'api/results/result',  move: move
  end
)
