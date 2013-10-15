FactoryGirl.define do
  factory :user do
    email { Forgery(:email).address }
    password { Forgery(:basic).password }
    password_confirmation { password }
  end
end
