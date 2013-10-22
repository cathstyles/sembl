class AddGameAttributesToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :game_attributes, :text, null: false, default: '{"nodes": [{"round": 0}], "links": []}'
  end
end
