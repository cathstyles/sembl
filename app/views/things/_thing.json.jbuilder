json.(@thing || thing, 
  :id,
  :title, 
  :description, 
  :copyright,
  :attribution, 
  :access_via, 
  :general_attributes
)

json.image_admin_url (@thing || thing).image.admin_thumb.url
json.image_browse_url (@thing || thing).image.browse_thumb.url
