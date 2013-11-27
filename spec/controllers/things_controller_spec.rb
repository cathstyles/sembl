require 'spec_helper'

describe ThingsController do
  describe 'GET 'in describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end
end
