class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :board
      t.string :title, null: false
      t.text :description

      t.references :creator, index: true
      t.references :updator, index: true
      t.timestamps
    end
  end
end
