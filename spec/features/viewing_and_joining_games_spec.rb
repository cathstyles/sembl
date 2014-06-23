require "spec_helper"

describe "Viewing and joining an open game", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }

  before do
    create_game_for user1
  end

  context "when user is not signed in" do
    before do
      click_on "Animals"
    end
    it "should only have locked nodes" do
      expect(page).to have_no_content "Join Game"
      locked_nodes = page.evaluate_script("$('.state-locked').length")
      expect(locked_nodes).to eq(6) # 7 total nodes, 6 locked, 1 seed node
    end
  end

  context "when user is signed in" do
    before do
      sign_in user2
    end
    pending "should show games that the user is participating in"
    it "should allow the user to join a game" do
      click_on "Games you can join"
      click_on "Animals"
      click_on "Join Game"
      expect(page).to have_content "Let's go! Add your first image to begin the game"
      expect(page).to have_css ".state-available"
      find(".state-available").click
      expect(page).to have_content "Click the camera to choose an image from the gallery"
      expect(page).to have_css ".state-available"
      sleep(1)
      find(".state-available").click
      # debugger
      expect(page).to have_css ".games__gallery__thing"
      first(".games__gallery__thing").click
      expect(page).to have_content "Little Monkey"
      first(".move__thing-modal__place-button").click
      sleep 3
      # raise "yep"
      expect(page).to have_css ".game__resemblance__tip"
      first(".game__resemblance__tip").trigger("click")

      expect(page).to have_content "What’s the resemblance between"

      first("input").fill_in with: "Some sembl connection"

      click_on "Add Sembl"

      expect(page).to have_content "Happy with your move? Submit to keep playing"
      first(".move__actions__button").click
      # raise "hi"
    end
  end
end
