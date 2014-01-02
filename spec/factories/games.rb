# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :game do
    title { Forgery(:lorem_ipsum).word }
    theme { Forgery(:lorem_ipsum).word }
    board { FactoryGirl.create(:board) }

    factory :game_in_progress do 
      number_of_players { 3 }
      state { 'draft' }
      after(:create) do |game|
        FactoryGirl.create_list(:player, 3, game: game, state: 'playing_turn')
        game.state = 'playing'
      end
    end

    factory :game_being_joined do 
      number_of_players { 3 }
      state { 'joining' }
      invite_only { false }
      before(:create) do |game|
        FactoryGirl.create_list(:player, 2, game: game, state: 'playing_turn')
      end
    end 

    factory :game_with_nodes do 
      after(:create) do |game|
        (0..4).each do |i|
          FactoryGirl.create(:node, game: game, round: i)
        end
      end
    end
  end
end
