FactoryGirl.define do
  factory :thing do
    title { "Little Monkey" }
    description { "Monkeys are clearly the coolest things on Earth." }
    image { File.open(File.join(Rails.root, '/spec/support/images/monkey.jpg')) }
  end
end
