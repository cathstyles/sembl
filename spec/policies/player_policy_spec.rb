require 'spec_helper'

describe PlayerPolicy do 
  subject { PlayerPolicy.new(user, game)}

  let(:game) { FactoryGirl.create(:game) }
  let(:game_creator) { FactoryGirl.create(:user) }
  let(:player) { FactoryGirl.create(:player, user: user, game: game)}

  context "for a guest" do 
    let(:user) { nil }

    it { should_not permit(:end_turn)  }
  end

  context "for a user" do 
    let(:user) { FactoryGirl.create(:user) }

    it { should_not permit(:end_turn) }
  
    context "for a game that is hosted by user" do 
      let(:game) { FactoryGirl.create(:game, creator: user) }
      it { should_not permit(:end_turn) }
    end
  end
end