require "spec_helper"

describe PlayerMailer do
  describe "game_invitation" do
    let(:mail) { PlayerMailer.game_invitation }

    it "renders the headers" do
      mail.subject.should eq("Game invitation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
