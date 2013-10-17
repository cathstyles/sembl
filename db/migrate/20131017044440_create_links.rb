class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :source, index: true
      t.references :target, index: true
      t.references :game, index: true
      t.timestamps
    end
  end
end
