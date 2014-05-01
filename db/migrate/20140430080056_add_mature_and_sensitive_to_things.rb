class AddMatureAndSensitiveToThings < ActiveRecord::Migration
  def up
    add_column :things, :sensitive, :boolean, default: false
    add_column :things, :mature, :boolean, default: false

    Thing.all.each do |thing|
      thing.mature = false
      thing.sensitive = false
      thing.save!
    end
  end

  def down
    remove_column :things, :sensitive
    remove_column :things, :mature
  end
end
