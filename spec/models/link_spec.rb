require 'spec_helper'

describe Link do
  subject(:link) { described_class.new }
  let(:user) { FactoryGirl.create(:user) }


  describe "helpers" do 
    context "has resemblances" do 
      before do 
        link.resemblances.build(description: "hi", creator: user, state: 'proposed')
        link.resemblances.build(description: "hi", creator: nil, state: 'proposed')
        link.resemblances.build(description: "hi", creator: user, state: 'final')
        link.save!
      end

      describe "#player_resemblance" do
        it "returns the proposed resemblance owned by user" do
          link.player_resemblance(user).should be_a(Resemblance)
          link.player_resemblance(user).should be_proposed
          link.player_resemblance(user).creator.should == user
        end
      end

      describe "#final_resemblance" do 
        it "returns the final resemblance" do 
          link.final_resemblance.should be_a(Resemblance)
          link.final_resemblance.should be_final 
        end
      end


      describe "#viewable_resemblance" do 
       it "returns the resemblance viewable by current user" do 
          link.viewable_resemblance(user).should be_a(Resemblance)
          link.viewable_resemblance(user).should be_final 
        end

        it "returns the users resemblance if there is no final resemblance" do 
          link.resemblances.with_state(:final).destroy_all
          link.viewable_resemblance(user).should be_a(Resemblance)
          link.viewable_resemblance(user).should be_proposed
          link.viewable_resemblance(user).creator.should == user
        end
      end

    end
  end
end
