json.array! (
  json.awards @awards.all do |json, award|
    json.partial! 'api/results/award',  award: award
  end
)