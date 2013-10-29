require "pp"

class SplitBoardGameAttributesIntoNodesAndLinks < ActiveRecord::Migration
  def up
    add_column :boards, :nodes_attributes, :json, null: false, default: "[{\"round\": 0}]"
    add_column :boards, :links_attributes, :json, null: false, default: "[]"

    Board.find_each do |board|
      json = JSON.parse(board.game_attributes)
      board.nodes_attributes = json["nodes"]
      board.links_attributes = json["links"]
      board.save!
    end

    remove_column :boards, :game_attributes
  end
end
