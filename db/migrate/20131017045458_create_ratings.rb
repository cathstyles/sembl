class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :rating
      t.references :resemblance, index: true
      t.references :creator, index: true
      t.timestamps
    end
  end
end
