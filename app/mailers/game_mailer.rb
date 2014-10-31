# Subjects are set in config/locales/en.yml (see en.game_mailer.*)
class GameMailer < ActionMailer::Base
  helper :game

  default from: "info@sembl.com"

  def player_invitation(player_id)
    setup player_id

    @existing_user = @player.user.present?
    @email = @player.try(:user).try(:email) || @player.email

    mail to: @email
  end

  def game_started(player_id)
    setup player_id

    @existing_user = @player.user.present?
    @email = @player.try(:user).try(:email) || @player.email

    mail to: @email
  end

  def player_turn_reminder(player_id)
    setup player_id

    mail to: @player.user.email
  end

  def game_completed(player_id)
    setup player_id

    mail to: @player.user.email
  end

  def game_stale_and_incomplete_player_set(player_id)
    setup player_id

    mail to: @player.user.email
  end

  private

  def setup(player_id)
    @player = Player.find(player_id)
    @game = @player.game
  end
end
