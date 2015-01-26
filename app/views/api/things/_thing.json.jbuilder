json.(@thing || thing,
  :id,
  :title,
  :description,
  :copyright,
  :attribution,
  :access_via,
  :item_url,
  :dates,
  :keywords,
  :places,
  :node_type
)

json.image_admin_url (@thing || thing).image.admin_thumb.url
json.image_large_url (@thing || thing).image.large.url
json.image_browse_url (@thing || thing).image.browse_thumb.url
