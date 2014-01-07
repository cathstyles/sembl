require "spec_helper"

describe PlayerMailer do
  describe "#game_invitation" do
    let(:player) { Player.create(user: FactoryGirl.create(:user), game: FactoryGirl.create(:game) ) }
    let(:mail) { PlayerMailer.game_invitation(player) }

    it "renders the headers" do
      player.user.email = "to@example.org"
      mail.subject.should eq("You have been invited to join a Sembl game.")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["info@sembl.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match(/You have been invited/)
    end
  end

end
