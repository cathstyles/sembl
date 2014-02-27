json.description resemblance.try(:description)
json.score resemblance.try(:score)

json.user do
  json.partial! 'api/users/user', user: resemblance.try(:creator)
end