class PlayerMailer < ActionMailer::Base
  default from: "info@sembl.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.player_mailer.game_invitation.subject
  #
  def game_invitation(player)
    @game = player.game
    if player.user.present?
      @existing_user = true
      @email = player.try(:user).try(:email)
    else
      @existing_user = false
      @email = player.email
    end

    mail to: @email
  end
end
