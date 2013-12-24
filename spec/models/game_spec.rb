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
        game.stub(:number_of_players) { 3 }
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
end
