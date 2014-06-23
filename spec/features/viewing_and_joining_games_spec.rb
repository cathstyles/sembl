require "spec_helper"

describe "Viewing and joining an open game", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  before do
    create_game user1, "Animals"
  end

  context "when user is not signed in" do
    before do
      click_on "Animals"
    end
    it "should only show locked nodes" do
      expect(page).to have_no_content "Join Game"
      locked_nodes = page.evaluate_script("$('.state-locked').length")
      expect(locked_nodes).to eq(6) # 7 total nodes: 6 locked, 1 seed
    end
  end

  context "when user is signed in" do
    before do
      sign_in user2
    end
    it "should allow the user to join a game and play a turn" do
      click_on "Open games"
      click_on "Animals"
      click_on "Join Game"
      play_turn
      expect(page).to have_content "your turn is complete"
      sign_out_current_user
    end
    pending "should show games that the user is participating in"
  end
end
