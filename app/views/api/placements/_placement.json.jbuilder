json.score placement.score
json.(placement, :created_at)
json.thing_id placement.try(:thing).try(:id)
json.image_url placement.try(:thing).try(:image).try(:url)
json.image_thumb_url placement.try(:thing).try(:image).try(:browse_thumb).try(:url)
json.title placement.try(:thing).try(:title)
json.thing do
  json.partial! 'api/things/thing', thing: placement.thing
end
if placement.creator.present?
  json.creator do
    json.partial! 'api/users/user', user: placement.creator
  end
end
