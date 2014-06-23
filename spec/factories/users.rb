FactoryGirl.define do
  factory :user do
    email { Forgery(:email).address }
    password { Forgery(:basic).password(at_least: 8) }
    password_confirmation { password }
    after(:create) do |user|
      user.profile.name = Forgery(:lorem_ipsum).words(2)
      user.profile.save!
    end

    trait :admin do
      role_event { 'make_admin' }
    end

    trait :power_user do 
      role_event { 'make_power_user' }
    end
  end
end
