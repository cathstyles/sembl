# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    title { Forgery(:lorem).word }
    theme { Forgery(:lorem).word }

  end
end
