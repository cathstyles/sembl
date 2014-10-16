class UserMailer < ActionMailer::Base
  default from: "info@sembl.com"

  # Player has just created an account:
  # TODO
  def welcome(user_id)
    @user = User.find(user_id)

    mail to: @user.email
  end
end
