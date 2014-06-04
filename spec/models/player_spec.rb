# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  game_id    :integer
#  user_id    :integer
#  score      :float            default(0.0), not null
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)      not null
#  email      :string(255)
#  move_state :string(255)
#

require 'spec_helper'

describe Player do

  subject(:player) { described_class.new }

  describe "validations" do
    before do
      player.stub(:allocate_first_node)
      player.game = Game.new()
    end
    xit { should validate_uniqueness_of(:user_id).scoped_to(:game_id).allow_nil() }
  end
  describe "states" do
    before do
      player.stub(:allocate_first_node)
      player.game = Game.new()
    end
    describe ":draft" do
      it "is the initial state" do
        player.should be_draft
      end

      it "transitions to playing_turn on invite if registered user is present" do
        PlayerMailer.stub(:game_invitation).and_return(double.tap{|d| d.stub(:deliver )})
        player.user = User.new
        player.invite
        player.should be_playing_turn
      end

      it "transitions to invited on invite if no registered user is present" do
        PlayerMailer.stub(:game_invitation).and_return(double.tap{|d| d.stub(:deliver )})
        player.email = 'player@example.com'
        player.invite
        player.should be_invited
      end

      it "sends and email invitation on any state transition" do
        player.email = 'player@example.com'
        PlayerMailer.should receive(:game_invitation).and_return(double.tap{|d| d.stub(:deliver )})
        player.invite
      end

    end

    describe ":invited" do
      before do
        player.state = 'invited'
      end

      it "transitions to playing_turn on join" do
        player.user = User.new
        player.join
        player.should be_playing_turn
      end

      it { should validate_presence_of(:email) }
    end

    describe ":playing_turn" do
      before do
        player.state = 'playing_turn'
      end
      it "transitions to waiting on end_turn" do
        player.stub(:move_created?).and_return(true)
        player.end_turn
        player.should be_waiting
      end

      it { should validate_presence_of(:user) }

      xit "validates turn completion requirements"
    end

    describe ":rating" do
      before do
        player.state = 'rating'
      end
      it "transitions to waiting on end_rating" do
        player.end_rating
        player.should be_waiting
      end

      xit "validates rating completion requirements"

    end

    describe ":waiting" do
      before do
        player.state = 'waiting'
        player.user = User.new
      end

      it "transitions to playing_turn on begin_turn" do
        player.begin_turn
        player.should be_playing_turn
      end

      it "transitions to rating on begin_rating" do
        player.begin_rating
        player.should be_rating
      end

    end

  end

  describe "callbacks" do
    describe "#allocate_first_node" do

      before do
        player.game = FactoryGirl.create(:game_with_nodes)
        player.user = FactoryGirl.create(:user)
        player.save!
      end

      it "allocates an available, 'in play' node to user" do
        player.allocate_first_node
        player.game.nodes.select{|n| n.allocated_to == player.user }.count.should == 1
        allocated = player.game.nodes.detect{|n| n.allocated_to == player.user }
        allocated.round.should == 1
        allocated.should be_in_play
      end

      it "does not allocated a node already taken" do
        allocated_node = player.game.nodes.build(round: 1, allocated_to: User.new)
        player.game.save!
        allocated_node.should be_in_play

        player.allocate_first_node
        player.game.nodes.detect{|n| n.allocated_to == player.user }.id.should_not == allocated_node.id
      end

    end

    describe "#check_turn_completion" do
      before do
        player.game = FactoryGirl.create(:game_in_progress)
      end
      it "should notify game when all players have completed turn" do
        player.game.players.each {|p|
          p.state = 'waiting'
          p.save!
        }
        player.game.should receive(:turns_completed)
        player.check_turn_completion
      end

      it "should not notify game when 2 players have completed turn" do
        player.game.players[1].state = 'waiting'
        player.game.players[2].state = 'waiting'
        player.game.save!
        player.game.should_not receive(:turns_completed)
        player.check_turn_completion
      end

    end

    describe "#check_rating_completion" do
      before do
        player.game = FactoryGirl.create(:game_in_progress)
      end
      it "should notify game when all players have completed rating" do
        player.game.players.each {|p|
          p.state = 'waiting'
          p.save!
        }
        player.game.should receive(:ratings_completed)
        player.check_rating_completion
      end

      it "should not notify game when 2 players have completed rating" do
        player.game.players[1].state = 'waiting'
        player.game.players[2].state = 'waiting'
        player.game.save!
        player.game.should_not receive(:ratings_completed)
        player.check_rating_completion
      end
    end

    describe "#calculate_score" do
      before do

        player.user = FactoryGirl.create(:user)
        player.game = FactoryGirl.create(:game_with_completed_nodes)

        player.game.nodes.each_with_index do |node, i|
          node.placements.each do |placement|
            placement.score = i+1
            placement.creator = player.user
            placement.save!
          end
        end

      end

      it "should caclulate the average of the placement scores" do
        player.calculate_score
        player.score.should > 0
      end
    end

  end
end
