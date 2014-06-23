module FeatureHelpers
  def sign_in(user)
    visit "/"
    within ".masthead__inner" do
      click_on "Sign in"
    end
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
    expect(page).to have_content "Signed in successfully."
  end

  def sign_out_current_user
    visit "/"
    click_on "Sign out"
  end

  def create_game_for(user)
    FactoryGirl.create(:board, number_of_players: 3, title: "Lotus 3")
    FactoryGirl.create(:thing)

    sign_in user

    click_on "Create a new game"
    expect(page).to have_content "Let’s get started! First, choose a board"
    click_on "Lotus 3"
    click_on "Next"
    fill_in "setup__steps__title__input", with: "Animals"
    click_on "Next"

    expect(page).to have_css ".game__placement.state-available"
    first(".game__placement.state-available").click

    expect(page).to have_css ".games__gallery__thing"
    first(".games__gallery__thing").click 

    click_on "Set as seed node"

    click_on "Done!"
    sleep 1 # this is needed because of the polling works and the edit page refreshes (I think).
    expect(page).to have_css ".setup__overview__actions__publish__button"
    first(".setup__overview__actions__publish__button").click

    expect(page).to have_css ".setup__overview__actions__show__button"
    first(".setup__overview__actions__show__button").click

    expect(page).to have_content("JOIN GAME")

    sign_out_current_user
    expect(page).to have_content("Signed out successfully")
  end
end
