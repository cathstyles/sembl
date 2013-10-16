FactoryGirl.define do
  factory :board do
    title { "#{Forgery(:lorem).word} #{number_of_players}" }
    number_of_players { (2..6).to_a.sample }
  end
end
