json.description resemblance.try(:description)
json.score resemblance.try(:score)
json.link_description resemblance.try(:source_description)
json.target_description resemblance.try(:target_description)

json.user do
  json.partial! 'api/users/user', user: resemblance.try(:creator)
end
