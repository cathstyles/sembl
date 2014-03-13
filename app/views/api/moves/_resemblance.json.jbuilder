json.(resemblance, :id, :description, :score)

if include_rating
  json.rating resemblance.rating_by(current_user).try(:rating)
end