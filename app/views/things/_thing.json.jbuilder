json.(@thing, 
  :title, 
  :description, 
  :copyright,
  :attribution, 
  :access_via, 
  :general_attributes
)

json.image_admin_url @thing.image.admin_thumb.url
json.image_browse_url @thing.image.browse_thumb.url
