require "spec_helper"

def rate(ratings)
  ratings.each do |rating|
    expect(page).to have_content "Rate this Sembl"
    page.execute_script "$('#rating__rate__input').val(#{rating}).trigger('change')"
    expect(page).to have_content "Rating submitted"
    first(".flash__close").trigger("click")
    first(".rating__nav__next").trigger("click")
  end
end

def play_a_round(players)
  players.each_with_index do |player, index|
    sign_in player
    click_on "Open to join"
    click_on "Animals"
    click_on "Join this game"
    play_turn(player.profile.name)
    unless index == (players.length - 1)
      expect(page).to have_content "your turn is complete"
    end
    sign_out_current_user
  end
end

def rate_a_round(players_with_scores)
  players_with_scores.each_with_index do |player_with_scores, index|
    user = player_with_scores[0]
    scores = player_with_scores[1]
    sign_in user
    click_on "Animals"
    rate scores
    if index == (players_with_scores.length - 1)
      expect(page).to have_css ".results__grouped:nth-child(1)" # ratings page
      # Alert, not signing out!
    else
      expect(page).to have_content "just waiting for everyone else to finish rating"
      sign_out_current_user
    end
  end
end

def assert_round_results(players_with_results)
  # results should be listed from highest scorer to lowest
  players_with_results.sort_by {|k,v| -v}.each_with_index do |user_score, index|
    user = user_score[0]
    score = user_score[1]
    within ".results__grouped:nth-child(#{index+1})" do
     expect(page).to have_content user.profile.name
     expect(page).to have_content score
    end
  end
end

def assert_overall_results(players_with_results)
  # results should be listed from highest scorer to lowest
  players_with_results.sort_by {|k,v| -v}.each_with_index do |user_score, index|
    user = user_score[0]
    score = user_score[1]
    within ".results__player-score:nth-child(#{index+1})" do
     expect(page).to have_content user.profile.name
     expect(page).to have_content score
    end
  end
end

feature "Playing a whole game", js: true do
  let!(:user1) { FactoryGirl.create(:user) }
  let!(:user2) { FactoryGirl.create(:user) }
  let!(:user3) { FactoryGirl.create(:user) }
  let!(:board) { FactoryGirl.create(:board, number_of_players: 3) }
  let!(:thing) { FactoryGirl.create(:thing) }

  scenario "3 people playing a game from start to finish" do
    create_hostless_game board, "Animals", thing

    # Round 1!!
    play_a_round [user1, user2, user3]

    # user1 gives user2 a score of 60 and user 3 a score of 40
    # user2 gives user1 a score of 30 and user 3 a score of 50
    # user3 gives user1 a score of 10 and user 2 a score of 70
    rate_a_round [[user1, [60,40]], [user2, [30,50]], [user3, [10,70]]]

    # Round 1 results
    assert_round_results [[user1, 20], [user2, 65], [user3, 45]]

    # Overall results
    assert_overall_results [[user1, 20], [user2, 65], [user3, 45]]
    sign_out_current_user
  end
end
