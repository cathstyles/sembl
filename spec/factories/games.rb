# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    title { Forgery(:lorem_ipsum).word }
    theme { Forgery(:lorem_ipsum).word }
    board { FactoryGirl.create(:board) }

    factory :game_in_progress do 
      after(:create) do |game|
        FactoryGirl.create_list(:player, 3, game: game, state: 'playing')
      end
    end
  end
end
