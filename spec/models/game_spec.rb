# == Schema Information
#
# Table name: games
#
#  id                   :integer          not null, primary key
#  board_id             :integer
#  title                :string(255)      not null
#  description          :text
#  creator_id           :integer
#  updator_id           :integer
#  created_at           :datetime
#  updated_at           :datetime
#  invite_only          :boolean          default(FALSE)
#  uploads_allowed      :boolean          default(FALSE)
#  theme                :string(255)
#  filter_content_by    :text
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)
#  current_round        :integer          default(1)
#  random_seed          :integer
#  number_of_players    :integer
#

require 'spec_helper'

describe Game do
  subject(:game) { FactoryGirl.build(:game) }

  describe "validations" do 
    it { should validate_presence_of :title }
    it { should validate_presence_of :board }

    context "has 3 player board" do 
      before do 
        game.number_of_players = 3
      end

      it "is invalid if players > 3" do 
        game.stub(:players) { Array.new(4, double) }
        game.should_not be_valid
      end

      it "is valid if players === 3" do 
        game.stub(:players) { Array.new(3, double) }
        game.should be_valid
      end

      #TODO this should be in state machine tests.
      context "is invite only" do
        before do 
          game.stub(:invite_only) { true }
        end
        context "state is playing" do 
          before do 
            game.stub(:state) { 'playing' }
          end
          it "is invalid if 2 players have been created" do
            game.stub(:players) { Array.new(2, double) }
            game.should_not be_valid
          end
        end
      end
    end
    
    context "game is public" do 
      before do 
        game.stub(:invite_only) { false }
      end
      it "is invalid if image uploads have been allowed" do 
        game.stub(:uploads_allowed) { true }
        game.should_not be_valid
      end
    end 
  end

  describe "scopes" do 
  end

  describe "helpers" do 
    describe "#has_open_places?" do
      before do 
        game.number_of_players = 3
      end
      it "is true if not all have been created" do 
        game.stub(:players) { Array.new(2, double) }
        game.should be_with_open_places
      end
      it "is false if all players have been created" do 
        game.stub(:players) { Array.new(3, double) }
        game.should_not be_with_open_places
      end
    end

    describe "#open_to_join?" do 
      before do 
        game.number_of_players = 3
      end

      context "open to public and published" do 
        before do 
          game.invite_only = false
          game.state = 'open'
        end
        it "is open if 2 players have joined" do 
          2.times do 
            game.players.build(user: FactoryGirl.create(:user))
            game.save!
            game.join
          end
          game.should be_open_to_join 
        end
        it "is not open if 3 players have joined" do 
          3.times do 
            game.players.build(user: FactoryGirl.create(:user))
            game.save!
            game.join
          end
          game.should_not be_open_to_join 
        end

      end
      
    end

    describe "#final_round" do 
      subject(:game) { FactoryGirl.create(:game_with_nodes) }

      it "has the correct final round" do 
        game.final_round.should == 4
      end
    end

    describe "#final_round?" do 
      subject(:game) { FactoryGirl.create(:game_with_nodes) }

      it "should be true if the current round is the final round" do 
        game.current_round = 4
        game.should be_final_round
      end

      it "should be false if the current round is not the final round" do 
        game.current_round = 3
        game.should_not be_final_round
      end
    end

    describe "#participating?" do 
      let(:user) { FactoryGirl.create(:user) }

      it "should be false if user is a not a player" do
        game.participating?(user).should be_false
      end


      it "shoudl be true if user is a player" do 
        game.players.build(user: user)
        game.save
        game.participating?(user).should be_true
      end
    end

    describe "#hosting?" do 
      let(:user) { FactoryGirl.create(:user) }
      it "should be false if user is not the creator" do
        game.hosting?(user).should be_false
      end


      it "should be true if user is the creator" do 
        game.stub(:creator) { user }
        game.hosting?(user).should be_true
      end
    end

    describe "#player" do 
      let(:user) { FactoryGirl.create(:user) }
      it "should return a player if the user is a player" do 
        game.players.build(user: user)
        game.save
        game.player(user).should be_a(Player)
      end
      
      it "should return the user's player if the user is a player" do 
        game.players.build(user: user)
        game.players.build(user: FactoryGirl.create(:user))
        game.save
        game.player(user).user.should == user
      end
    end

    describe "#seed_node" do 
      subject(:game) { FactoryGirl.create(:game_with_nodes) }
      
      it "should return a node" do 
        game.seed_node.should be_a(Node)
      end

      it "should return the node with round === 0" do
        game.seed_node.round.should == 0
      end
    end

    describe "#seed_thing" do 
      subject(:game) { FactoryGirl.create(:game_with_nodes) }
      let(:thing) { Thing.create }

      context "has a final placement" do 
        before do 
          game.seed_node.placements.create(state: 'final', thing: thing)
        end

        xit "returns a thing" do 
          game.seed_thing.should be_a(Thing)
        end
      end

      context "has a proposed thing" do 
        before do 
          game.seed_node.placements.build(thing: thing)
        end

        xit "does not return a thing" do 
          game.seed_thing.should_not be_a(Thing)
        end
      end

    end


  end

#   def seed_thing 
#     seed_node.try(:final_placement).try(:thing)
#   end




end
