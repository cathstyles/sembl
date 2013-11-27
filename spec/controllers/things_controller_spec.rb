require 'spec_helper'

describe ThingsController do
  describe "GET 'index'" do
    it "returns http success" do
      @game = FactoryGirl.create(:game)
      get :index, game_id: @game.id
      response.should be_success
    end
  end 
end
