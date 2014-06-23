require "spec_helper"

feature "Playing a whole game", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }

  scenario "3 people playing a game from start to finish" do
    create_game user1, "Animals"
    
    sign_in user1
    click_on "Open games"
    click_on "Animals"
    click_on "Join Game"
    play_turn
    expect(page).to have_content "your turn is complete"
    sign_out_current_user
    
    sign_in user2
    click_on "Open games"
    click_on "Animals"
    click_on "Join Game"
    play_turn
    expect(page).to have_content "your turn is complete"
    sign_out_current_user

    sign_in user3
    click_on "Open games"
    click_on "Animals"
    click_on "Join Game"
    play_turn
    expect(page).to have_content "Rate this Sembl"
    raise "yeah"
  end
end
