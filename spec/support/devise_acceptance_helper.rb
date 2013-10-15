module DeviseAcceptanceHelper
  def login user
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end

  def logout
    click "Sign out"
  end
end

RSpec.configure do |config|
  config.include DeviseAcceptanceHelper, type: :feature
end
