class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :creator, index: true
      t.references :updator, index: true
      t.timestamps
    end
  end
end
