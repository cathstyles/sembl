class PlayerMailer < ActionMailer::Base
  default from: "info@sembl.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.player_mailer.game_invitation.subject
  #
  def game_invitation(player)
    @game = player.game
    email = player.try(:user).try(:email) || player.email

    mail to: email
  end
end
