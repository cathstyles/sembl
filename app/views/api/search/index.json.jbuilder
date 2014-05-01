json.hits do 
  json.array! (
    json.things @things, partial: 'api/things/thing', as: :thing
  )
end
json.total @total