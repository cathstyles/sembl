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
    expect(page).to have_content "Signed out successfully."
  end

  def create_game(user, game_name)
    FactoryGirl.create(:board, number_of_players: 3, title: "Lotus 3")
    FactoryGirl.create(:thing)
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

  def create_hostless_game(board, title, seed_thing)
    game = Game.new(board: board,
      title: title,
      description: "A game for #{board.number_of_players} #{'player'.pluralize(board.number_of_players)}, starting with:",
      seed_thing_id: Thing.last.id,
      state: "draft")
    game.copy_nodes_and_links_from_board
    update_seed_thing(game, seed_thing)
    game.state = "open"
    game.save!
    game
  end

  def update_seed_thing(game, thing)
    if seed_thing = thing
      seed_node = game.nodes.detect {|node|
        node.round == 0 && !node.marked_for_destruction?
      }
      return unless seed_node
      placement = seed_node.placements[0] || seed_node.placements.build
      placement.assign_attributes(
        thing: seed_thing
      )
    end
  end

  def play_turn(round, resemblance_description = "They're, like, so obviously similar", user)
    if round > 1
      expect(page).to have_content "Select an open position"
    else
      expect(page).to have_content "Let's go! Add your first image to begin the game"
    end
    expect(page).to have_css ".state-available"
    if round > 1
      inplay_and_unplaced_nodes = @game.nodes.where("nodes.state = 'in_play'") - @game.nodes.joins(:placements)
      if inplay_and_unplaced_nodes.length > 0
        find("a[data-node-id='#{inplay_and_unplaced_nodes.first.id}']").click
      else
        find(".state-available", match: :first).click
      end
      expect(page).to have_content "Make your move!"
    else
      find(".state-available", match: :first).click
      expect(page).to have_content "Click the camera to choose an image from the gallery"
    end
    expect(page).to have_css ".state-available"
    find(".state-available").click
    expect(page).to have_content "CLOSE"
    sleep 1 #WHHHHY?
    expect(page).to have_css ".games__gallery__thing"
    find(".games__gallery__thing", match: :first).click
    expect(page).to have_css ".move__thing-modal__place-button"
    find(".move__thing-modal__place-button", match: :first).click

    expect(page).to have_css ".game__resemblance__tip"

    # (1..round).each do |i|
    find(".game__resemblance__tip", match: :first)
    while all(".game__resemblance__tip").present? do
      find(".game__resemblance__tip", match: :first).click
      expect(page).to have_content "What’s the resemblance between"
      fill_in "move__resemblance__description", with: "round #{round}: " + resemblance_description
      click_on "Add Sembl"
      sleep 1
    end

    expect(page).to have_content "Happy with your move?"
    expect(page).to have_css ".move__actions__button"
    find(".move__actions__button", match: :first).click
    expect(page).to have_content "Happy with your move?"
    page.click_on "End your turn"
  end
end
