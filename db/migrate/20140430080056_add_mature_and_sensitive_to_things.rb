class AddMatureAndSensitiveToThings < ActiveRecord::Migration
  def up
    add_column :things, :sensitive, :boolean
    add_column :things, :mature, :boolean
  end

  def down
    remove_column :things, :sensitive
    remove_column :things, :mature
  end
end
