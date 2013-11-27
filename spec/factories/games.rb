# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    title { Forgery(:lorem_ipsum).word }
    theme { Forgery(:lorem_ipsum).word }

  end
end
