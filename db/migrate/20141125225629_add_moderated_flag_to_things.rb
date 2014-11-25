class AddModeratedFlagToThings < ActiveRecord::Migration
  def up
    add_column :things, :moderated, :boolean, default: false
    Thing.update_all(moderated: false)
  end

  def down
    remove_column :things, :moderated
  end
end
