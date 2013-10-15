require "spec_helper"

describe "Admin area" do
  context "not logged in" do
    specify "asks to login" do
      visit "/admin"
      current_path.should == new_user_session_path
    end
  end

  context "as a normal user" do
    before { login(create(:user)) }

    specify "is not found" do
      # in test errors are raised, not rendered.
      expect { visit "/admin" }.to raise_error ActionController::RoutingError
    end
  end

  context "as an admin user" do
    before { login(create(:user, :admin)) }

    specify "is accessible" do
      visit "/admin"
    end
  end
end
