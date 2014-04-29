class AddGameToThing < ActiveRecord::Migration
  def up
    add_reference :things, :game, index: true
  end

  def down
    remove_reference :things, :game
  end
end
