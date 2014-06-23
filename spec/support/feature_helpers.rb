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

  def create_game(user, game_name)
    FactoryGirl.create(:board, number_of_players: 3, title: "Lotus 3")
    FactoryGirl.create(:thing)
    sign_in user
    click_on "Create a new game"
    expect(page).to have_content "Let’s get started! First, choose a board"
    click_on "Lotus 3"
    click_on "Next"
    fill_in "setup__steps__title__input", with: game_name
    click_on "Next"
    expect(page).to have_css ".game__placement.state-available"
    first(".game__placement.state-available").click
    expect(page).to have_css ".games__gallery__thing"
    first(".games__gallery__thing").click 
    click_on "Set as seed node"
    click_on "Done!"
    sleep 3 # this is needed because of the polling works and the edit page refreshes (I think).
    expect(page).to have_css ".setup__overview__actions__publish__button"
    first(".setup__overview__actions__publish__button").click
    expect(page).to have_css ".setup__overview__actions__show__button"
    first(".setup__overview__actions__show__button").click
    expect(page).to have_content("JOIN GAME")
    sign_out_current_user
    expect(page).to have_content("Signed out successfully")
  end

  def play_turn
    expect(page).to have_content "Let's go! Add your first image to begin the game"
    expect(page).to have_css ".state-available"
    find(".state-available").trigger "click"
    expect(page).to have_content "Click the camera to choose an image from the gallery"
    expect(page).to have_css ".state-available"
    sleep 1
    find(".state-available").click
    expect(page).to have_css ".games__gallery__thing"
    first(".games__gallery__thing").click
    expect(page).to have_content "Little Monkey"
    first(".move__thing-modal__place-button").click
    expect(page).to have_css ".game__resemblance__tip"
    first(".game__resemblance__tip").trigger("click")
    expect(page).to have_content "What’s the resemblance between"
    fill_in "resemblance-input", with: "Some sembl connection"
    click_on "Add Sembl"
    expect(page).to have_content "Happy with your move?"
    expect(page).to have_css ".move__actions__button"
    first(".move__actions__button").click
    expect(page).to have_content "Happy with your move?"
    page.click_on "End your turn"
  end
end
