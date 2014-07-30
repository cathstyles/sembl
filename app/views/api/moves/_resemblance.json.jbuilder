json.(resemblance, :id, :description, :score, :source_description, :target_description)

if include_rating
  json.rating resemblance.rating_by(current_user).try(:rating)
end
