admin = User.seed(:email) do |s|
  s.first_name      = "Admin"
  s.last_name       = "FMS"
  s.email           = "fms_admin@shk.com"
  s.password        = "password"
  s.password_confirmation  =  "password"
  s.single_access_token  =  rand(36**36).to_s(36)
end.first
