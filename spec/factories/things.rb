FactoryGirl.define do
  factory :thing do
    title { Forgery(:lorem).words(3) }
    description { Forgery(:lorem).paragraphs(2) }
  end
end
