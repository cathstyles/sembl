class CreateResemblances < ActiveRecord::Migration
  def change
    create_table :resemblances do |t|
      t.text :description, null: false 
      t.string :state, null: false
      t.float :score
      t.references :link, index: true
      t.references :creator, index: true
      t.timestamps
    end
  end
end
