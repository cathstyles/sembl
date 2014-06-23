require "spec_helper"

describe "Home page", js: true do
  let!(:game) { FactoryGirl.create(:game_with_nodes, title: "My game, yo", state: "open") }

  before do
    visit "/"
  end

  context "User is not signed in" do
    it "show sign in and sign up links" do
      expect(page).to have_content "Sign in"
      expect(page).to have_content "Sign up"
    end
    it "shows open games" do
      expect(page).to have_content "My game, yo"
    end
  end
end
