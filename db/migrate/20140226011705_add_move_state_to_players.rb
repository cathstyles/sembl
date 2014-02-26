class AddMoveStateToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :move_state, :string

    Player.reset_column_information
    Player.find_each do |player|
      player.move_state = 'open'
      player.save!
    end
  end
end
