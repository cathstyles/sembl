class UserMailer < ActionMailer::Base
  default from: "feedback@sembl.net"

  # Player has just created an account:
  # TODO
  def welcome(user_id)
    @user = User.find(user_id)

    mail to: @user.email
  end
end
