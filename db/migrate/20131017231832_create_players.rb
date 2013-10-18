class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.references :game
      t.references :user
      t.float :score
      t.timestamps
    end
  end
end
