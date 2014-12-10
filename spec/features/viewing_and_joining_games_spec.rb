require "spec_helper"

feature "Viewing, joining and playing games", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:board) { FactoryGirl.create(:board) }
  let!(:thing) { FactoryGirl.create(:thing) }

  scenario "a signed in user attempts to join a game and play a turn" do
    create_hostless_game board, "Animals", thing

    visit "/"
    sign_in user2
    click_on "Open to join"
    click_on "Animals"
    click_on "Join this game"
    play_turn

    expect(page).to have_content "your turn is complete"
    sign_out_current_user
  end

  pending "should show games that the user is participating in"
end
