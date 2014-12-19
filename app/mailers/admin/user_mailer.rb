class Admin::UserMailer < ActionMailer::Base
  default from: "Sembl <feedback@sembl.net>"
  def email_message(options)
    @user = User.find(options[:user_id])
    @message_content = options[:content]
    mail(to: @user.email, subject: options[:subject])
  end
end
