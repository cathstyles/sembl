AdminConstraint = lambda do |request|
  request.env["warden"].authenticate!(scope: :user) and
    request.env["warden"].user(:user).admin?
end
