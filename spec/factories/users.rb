FactoryGirl.define do
  factory :user do
    email { Forgery(:email).address }
    password { Forgery(:basic).password(at_least: 8) }
    password_confirmation { password }

    trait :admin do
      role_event { 'make_admin' }
    end

    trait :power_user do 
      role_event { 'make_power_user' }
    end
  end
end
