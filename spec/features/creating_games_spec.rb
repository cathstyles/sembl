require 'spec_helper'

feature "Creating games", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }

  scenario "Creating a game" do
    create_game user1, "Animals"
    # debugger
    # page.driver.debug
  end

end
