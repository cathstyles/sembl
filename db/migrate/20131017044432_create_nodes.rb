class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :game
      t.integer :round
      t.string :state
      t.references :allocated_to
      t.timestamps
    end
  end
end
