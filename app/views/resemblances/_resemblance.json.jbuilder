json.description resemblance.try(:description)
json.score resemblance.try(:score)

json.user do
  json.partial! 'users/user', user: resemblance.try(:creator)
end