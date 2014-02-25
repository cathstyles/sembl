# == Schema Information
#
# Table name: nodes
#
#  id              :integer          not null, primary key
#  game_id         :integer
#  round           :integer
#  state           :string(255)
#  allocated_to_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  x               :integer          default(0), not null
#  y               :integer          default(0), not null
#

require 'spec_helper'

describe Node do
  subject(:node) { described_class.new }
  let(:user) { FactoryGirl.create(:user) }


  describe "helpers" do 
    context "has placements" do 
      before do 
        node.round = 1
        node.placements.build(creator: user, state: 'proposed')
        node.placements.build(creator: nil, state: 'proposed')
        node.placements.build(creator: user, state: 'final')
        node.save!
      end

      describe "#player_placement" do
        it "returns the proposed placement owned by user" do
          node.player_placement(user).should be_a(Placement)
          node.player_placement(user).should be_proposed
          node.player_placement(user).creator.should == user
        end
      end

      describe "#final_placement" do 
        it "returns the final placement" do 
          node.final_placement.should be_a(Placement)
          node.final_placement.should be_final 
        end
      end


      describe "#viewable_placement" do 
        it "returns the placement viewable by current user" do 
          node.viewable_placement(user).should be_a(Placement)
          node.viewable_placement(user).should be_final 
        end

        it "returns the users placement if there is no final placement" do 
          node.placements.with_state(:final).destroy_all
          node.viewable_placement(user).should be_a(Placement)
          node.viewable_placement(user).should be_proposed
          node.viewable_placement(user).creator.should == user
        end
      end

    end

    describe "#available_to?" do 
      context "user is participating in game" do
        before do
          node.stub(:game) { 
            g = double
            g.stub(:participating?).and_return(true) 
            g 
          }
        end

        context "node is in play" do
          before do 
            node.state = 'in_play'
          end

          it "is available to user if it is allocated" do 
            node.stub(:allocated_to?).and_return(true)
            node.round = 1
            node.should be_available_to(user)
          end

          it "is available to user if it is > round 1" do 
            node.stub(:allocated_to?).and_return(false)
            node.round = 2
            node.should be_available_to(user)
          end

          it "is not available to user if round <= 1 and it is not allocated" do 
            node.stub(:allocated_to?).and_return(false)
            node.round = 1
            node.should_not be_available_to(user)
          end 
        end

        context "node is not in play" do 
          before do 
            node.state = 'locked'
          end
          it "is not available to user" do 
            node.should_not be_available_to(user)
          end
        end
      end 

      context "user in not participating in game" do 
        before do
          node.stub(:game) { 
            g = double
            g.stub(:participating?).and_return(false) 
            g 
          }
        end
        it "is not available to user" do 
          node.should_not be_available_to(user)
        end

      end 
    end

    describe "#allocated_to?" do 
      it "should be allocated if user has been assigned" do
        node.allocated_to = user
        node.should be_allocated_to(user)
      end

      it "should not be allocated if no user has been assigned" do 
        node.allocated_to = nil
        node.should_not be_allocated_to(user)
      end

      it "should not be allocated if another user has been assigned" do 
        node.allocated_to = FactoryGirl.create(:user)
        node.should_not be_allocated_to(user)
      end

    end

    describe "#user_state" do
      it "is locked if node is locked" do 
        node.state = 'locked'
        node.user_state(user).should == 'locked'
      end

      it "is fille if node is filled" do 
        node.state = 'filled'
        node.user_state(user).should == 'filled'
      end

      it "is proposed if node is available to user but player has made a move" do
        node.state = 'in_play'
        node.stub(:available_to?).and_return(true)
        node.stub(:player_placement).and_return(Placement.new)
        node.user_state(user).should == 'proposed'
      end

      it "is available if node is in play and available to user" do
        node.state = 'in_play'
        node.stub(:available_to?).and_return(true)
        node.stub(:player_placement).and_return(nil)
        node.user_state(user).should == 'available'
      end

      it "is locked if node is in play and not available to user" do 
        node.state = 'in_play'
        node.stub(:available_to?).and_return(false)
        node.user_state(user).should == 'locked'
      end
    end

  end
end
