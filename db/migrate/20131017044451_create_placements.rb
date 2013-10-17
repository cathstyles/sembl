class CreatePlacements < ActiveRecord::Migration
  def change
    create_table :placements do |t|
      t.string :state, null: false
      t.references :thing
      t.references :node
      t.references :creator, index: true
      t.timestamps
    end
  end
end
