FactoryGirl.define do
  factory :thing do
    title { Forgery(:lorem_ipsum).words(3) }
    description { Forgery(:lorem_ipsum).paragraphs(2) }
  end
end
