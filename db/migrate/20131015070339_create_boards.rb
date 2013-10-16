class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.string :title, null: false
      t.integer :number_of_players, null: false
      t.references :creator, index: true
      t.references :updator, index: true
      t.timestamps
    end
  end
end
