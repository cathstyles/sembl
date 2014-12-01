require "spec_helper"

def rate(ratings)
  ratings.each do |rating|
    expect(page).to have_content "Rate this Sembl"
    page.execute_script "$('#rating__rate__input').val(#{rating}).trigger('change')"
    expect(page).to have_content "Rating submitted"
    find(".flash__close", match: :first).click
    find(".rating__nav__next", match: :first).click
  end
end

def play_a_round(round, game, players)
  players.each_with_index do |player, index|
    sign_in player
    visit game_path(game)
    click_on("Join this game") unless round > 1
    play_turn(round, player.email, player)
    unless index == (players.length - 1)
      expect(page).to have_content "your turn is complete"
    end
    sign_out_current_user
  end
end

def rate_a_round(round, players_with_scores)
  players_with_scores.each_with_index do |player_with_scores, index|
    user = player_with_scores[0]
    scores = player_with_scores[1]
    sign_in user
    click_on "Animals"
    rate scores
    sleep 1 # waiting for game state to change. Is there a better way?
    if index == (players_with_scores.length - 1)
      if Game.last.state == "completed"
        click_on "View the results"
      else
        expect(page).to have_content "Round #{round} Results" # results page
      end
    else
      expect(page).to have_content "just waiting for everyone else to finish rating"
    end
    sign_out_current_user
  end
end

def assert_round_results(players_with_results)
  # results should be listed from highest scorer to lowest
  expect(page).to have_css ".results__player-move__move"
  players_with_results.each_with_index do |player_and_result, index|
    player = player_and_result[0]
    result = player_and_result[1]
    within ".results__round:last-child" do # for the final round, previous round results are shown before the most recent round
      within ".results__player-move__move:nth-child(#{index+1})" do
        expect(page).to have_content player.email
        expect(page).to have_content result
      end
    end
  end
end

def assert_overall_results(players_with_results)
  # results should be listed from highest scorer to lowest
  expect(page).to have_css ".results__player-score"
  players_with_results.each_with_index do |user_score, index|
    user = user_score[0]
    score = user_score[1]
    within ".results__player-score:nth-child(#{index+1})" do
     expect(page).to have_content user.profile.name
     expect(page).to have_content score
    end
  end
end

feature "Playing a whole freakin' game", js: true do
  let!(:user1) { FactoryGirl.create(:user, email: "user1@blah.com") }
  let!(:user2) { FactoryGirl.create(:user, email: "user2@blah.com") }
  let!(:user3) { FactoryGirl.create(:user, email: "user3@blah.com") }
  let!(:board) { FactoryGirl.create(:board, number_of_players: 3) }
  let!(:thing) { FactoryGirl.create(:thing) }

  scenario "3 people playing a game from start to finish" do
    @game = create_hostless_game board, "Animals", thing
    @user1 = user1

    ### Round 1 ###
    play_a_round 1, @game, [user1, user2, user3]

    # user1 rates user2's sembl 20
    # user1 rates user3's sembl 60
    # user2 rates user1's sembl 90
    # user2 rates user3's sembl 50
    # user3 rates user1's sembl 84
    # user3 rates user2's sembl 30
    rate_a_round 1, [[user1, [20,60]], [user2, [90,50]], [user3, [84,30]]]

    # Check results
    sign_in user1
    click_on "Animals"
    click_on "Results"
    assert_round_results [[user1, 87], [user3, 55], [user2, 25]]
    assert_overall_results [[user1, 87], [user3, 55], [user2, 25]]
    sign_out_current_user


    ### Round 2 ###
    play_a_round 2, @game, [user1, user2, user3]

    # user1 rates user2's 1st sembl 35
    # user1 rates user2's 2nd sembl 23
    # user1 rates user3's 1st sembl 45
    # user1 rates user3's 2nd sembl 50
    # user2 rates user1's 1st sembl 78
    # user2 rates user1's 2nd sembl 74
    # user2 rates user3's 1st sembl 65
    # user2 rates user3's 2nd sembl 52
    # user3 rates user1's 1st sembl 81
    # user3 rates user1's 2nd sembl 89
    # user3 rates user2's 1st sembl 33
    # user3 rates user2's 2nd sembl 22

    # user1's 1st sembl = (78+81)/2 = 79.5
    # user1's 2nd sembl = (74+89)/2 = 81.5
    #                                 80.5 (placement score)

    # user2's 1st sembl = (35+33)/2 = 34
    # user2's 2nd sembl = (23+22)/2 = 22.5
    #                                 28.25 (placement score)

    # user3's 1st sembl = (45+65)/2 = 55
    # user3's 2nd sembl = (50+52)/2 = 51
    #                                 53 (placement score)

    # Overall scores at this point
    # user1 = (80.5+87)/2 = 83.75 = 83 (floored)
    # user2 = (28.25+25)/2 = 26.625 = 26
    # user3 = (53+55)/2 = 54 = 54

    # Check results
    rate_a_round 2, [[user1, [35,23,45,50]], [user2, [78,74,65,52]], [user3, [81,89,33,22]]]
    sign_in user1
    click_on "Animals"
    click_on "Results"
    assert_round_results [[user1, 81], [user1, 79], [user3, 55], [user3, 51], [user2, 34], [user2, 22]]
    assert_overall_results [[user1, 83], [user3, 54], [user2, 26]]
    sign_out_current_user


    ### Round 3 ###

    # user1 rates user2's 1st sembl 12
    # user1 rates user2's 2nd sembl 16
    # user1 rates user2's 3rd sembl 21
    # user1 rates user3's 1st sembl 35
    # user1 rates user3's 2nd sembl 42
    # user1 rates user3's 3rd sembl 51
    # user2 rates user1's 1st sembl 82
    # user2 rates user1's 2nd sembl 86
    # user2 rates user1's 3rd sembl 90
    # user2 rates user3's 1st sembl 63
    # user2 rates user3's 2nd sembl 50
    # user2 rates user3's 3rd sembl 43
    # user3 rates user1's 1st sembl 95
    # user3 rates user1's 2nd sembl 83
    # user3 rates user1's 3rd sembl 85
    # user3 rates user2's 1st sembl 11
    # user3 rates user2's 2nd sembl 5
    # user3 rates user2's 3rd sembl 14

    # user2 = (12 + 11)/2 = 11.5
    # user2 = (16 + 5)/2  = 10.5
    # user2 = (21 + 14)/2 = 17.5
    #                     = 13.16 (placement score)

    # user3 = (35 + 63)/2 = 49
    # user3 = (42 + 50)/2 = 46
    # user3 = (51 + 43)/2 = 47
    #                     = 47.33 (placement score)

    # user1 = (82 + 95)/2 = 88.5
    # user1 = (86 + 83)/2 = 84.5
    # user1 = (90 + 85)/2 = 87.5
    #                     = 86.83 (placement score)

    # Overall scores at this point
    # user1 = (80.5+87+86.83)/3  = 84.77 (user's 3 placements added together)
    # user2 = (28.25+25+13.16)/3 = 22.14
    # user3 = (53+55+47.33)/3    = 51.78

    play_a_round 3, @game, [user1, user2, user3]
    rate_a_round 3, [[user1, [12,16,21,35,42,51]], [user2, [82,86,90,63,50,43]], [user3, [95,83,85,11,5,14]]]
    sign_in user1
    click_on "Your completed games"
    click_on "Animals"
    click_on "View the results"
    assert_round_results [[user1, 88], [user1, 87], [user1, 84], [user3, 49], [user3, 47], [user3, 46], [user2, 17], [user2, 11], [user2, 10]]
    assert_overall_results [[user1, 84], [user2, 51], [user3, 22]]
    sign_out_current_user
  end
end
