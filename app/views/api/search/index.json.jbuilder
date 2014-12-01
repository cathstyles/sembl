json.hits do
  json.array! (
    json.things @things, partial: 'api/things/thing', as: :thing
  )
end
json.total @total
json.page @things.current_page
json.per_page @things.per_page
json.total_pages @things.total_pages
