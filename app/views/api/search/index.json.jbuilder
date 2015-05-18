json.hits do
  json.array! (
    json.things @things, partial: 'api/things/thing', as: :thing
  )
end
json.total @total
json.page @current_page
json.per_page @per_page
json.total_pages @total_pages
