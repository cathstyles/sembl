class AlterColumnForThingModeration < ActiveRecord::Migration
  def up
    remove_column :things, :moderated
    add_column :things, :moderator_approved, :boolean
  end

  def down
    remove_column :things, :moderator_approved, :boolean
  end
end
