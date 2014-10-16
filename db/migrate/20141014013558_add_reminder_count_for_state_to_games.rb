class AddReminderCountForStateToGames < ActiveRecord::Migration
  def up
    add_column :games, :reminder_count_for_state, :integer, null: false, default: 0

    # Set this to a high number to start with, so that none of the existing records trigger notification emails
    Game.update_all(reminder_count_for_state: 10)
  end

  def down
    remove_column :games, :reminder_count_for_state
  end
end
