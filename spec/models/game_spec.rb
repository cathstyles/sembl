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
#  allow_keyword_search :boolean          default(FALSE)
#  state                :string(255)
#  current_round        :integer          default(1)
#  random_seed          :integer
#  number_of_players    :integer
#  filter_content_by    :json
#

require 'spec_helper'

describe Game do
  # Build a game with 3 players
  subject(:game) { FactoryGirl.build(:game) }

  describe "validations" do 
    it { should validate_presence_of :title }
    it { should validate_presence_of :board }
    it { should validate_presence_of :number_of_players }
    it { should validate_numericality_of :number_of_players}

    it { should_not allow_value(1).for(:number_of_players) }
    it { should allow_value(2).for(:number_of_players) }

    it "is invalid if players > 3" do 
      game.stub(:players) { Array.new(4, double) }
      game.should_not be_valid
    end

    it "is valid if players === 3" do 
      game.stub(:players) { Array.new(3, double) }
      game.should be_valid
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
      before do
        game.stub(:final_round).and_return(4)
      end
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
      let(:user) { FactoryGirl.build(:user) }

      it "should be false if user is a not a player" do
        game.participating?(user).should be_false
      end


      it "shoudl be true if user is a player" do 
        game.players.build(user: user)
        game.participating?(user).should be_true
      end
    end

    describe "#hosting?" do 
      let(:user) { FactoryGirl.build(:user) }
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

      # Skip validations so we don't have to upload an image
      let(:thing) { 
        t = FactoryGirl.build(:thing) 
        t.save(validate: false)
        t
      }

      context "has a final placement" do 
        before do 
          placement = game.seed_node.placements.create(thing: thing)
          placement.should be_final
        end

        it "returns a thing" do 
          game.seed_thing.should be_a(Thing)
        end
      end
    end
  end

  describe "transition callbacks" do 

    describe "#players_begin_playing" do 
      it "should begin all players turns" do
        player = double
        game.stub(:players) { Array.new(3, player) } 
        player.should receive(:begin_turn).exactly(3).times
        game.players_begin_playing
      end
    end

    describe "#players_begin_rating" do
      it "should begin all players rating" do 
        player = double
        game.stub(:players) { Array.new(3, player) } 
        player.should receive(:begin_rating).exactly(3).times
        game.players_begin_rating
      end 
    end

    describe "#invite_players" do 
      it "should invite all players if invite_only" do 
        game.invite_only = true
        player = double
        game.stub(:players) { Array.new(3, player) }
        player.should receive(:invite).exactly(3).times
        game.invite_players
      end
    end
    
    describe "#remove_draft_players" do 
      it "should remove all draft players" do 
        3.times { game.players.build(state: 'draft') }
        game.save!
        game.remove_draft_players
        game.players.count.should == 0
      end

      it "should not remove players in non-draft state" do 
        3.times { game.players.build(state: 'draft') }
        1.times { game.players.build(state: 'invited', email: 'xx') }
        game.save!
        game.remove_draft_players
        game.players.count.should == 1
      end
    end

    describe "#increment_round" do
      it "should increment current round by one" do
        game.current_round = 1
        -> { game.increment_round }.should change(game, :current_round).by(1)
        game.increment_round
      end
    end
  end

  describe "states" do 
    # initial state
    
    describe ":draft" do 
      it "should be the initial state" do
        game.should be_draft 
      end

      it "should transition to :open on :publish if public" do
        game.invite_only = false
        game.publish! 
        game.should be_open
      end

      context "invite only" do 
        before do 
          game.invite_only = true
        end
        it "should transition to :playing on :publish if it has 3 players" do
          game.stub(:players) { Array.new(3, Player.new )}
          game.publish! 
          game.should be_playing
        end

        it "should raise an error on :publish if it has < 3 players" do
          game.stub(:players) { Array.new(2, Player.new )}
          -> { game.publish! }.should raise_error
        end
      end

      ['join!', 'turns_completed!', 'ratings_completed!'].each do |action|
        it "should raise an error for #{action}" do
          -> { game.send(action) }.should raise_error
        end
      end
    end

    describe ":open" do 
      before do 
        game.state = 'open'
        game.invite_only = false
      end

      it "should transition to :joining on :join" do
        game.join!
        game.should be_joining
      end
    end

    describe ":joining" do 
      before do 
        game.state = 'joining'
        game.invite_only = false
      end
      context "game still has open places" do
        before do 
          game.stub(:players) { Array.new(2, double) }
        end 
        it "should not change state on :join" do 
          game.join! 
          game.should be_joining
        end
      end
      context "game has no open places" do 
        before do 
          game.stub(:players) { Array.new(3, double) }
        end

        it "should change to :playing on :join" do 
          game.join!
          game.should be_playing
        end
      end
      ['unpublish!', 'turns_completed!', 'ratings_completed!'].each do |action|
        it "should raise an error for #{action}" do
          -> { game.send(action) }.should raise_error
        end
      end
    end

    describe ":playing" do 
      before do 
        game.state = 'playing'
      end

      it "is invalid if < 3 players have been created" do
        game.stub(:players) { Array.new(2, double) }
        game.should_not be_valid
      end
    
      it "should change to :rating on :turns_completed" do 
        game.turns_completed!
        game.should be_rating
      end

    end

    describe ":rating" do 
      before do 
        game.state = 'rating'
        game.stub(:players) { Array.new(3, Player.new(state: 'rating')) }
      end

      it "should change to :playing on :rating_completed" do 
        game.ratings_completed!
        game.should be_playing
      end

      it "should change to :completed on :rating_completed in final round" do 
        game.stub(:final_round?).and_return(:true)
        game.ratings_completed!
        game.should be_completed
      end
    end
  end

end
