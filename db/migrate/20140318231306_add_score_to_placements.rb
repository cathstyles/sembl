class AddScoreToPlacements < ActiveRecord::Migration
  def change
    add_column :placements, :score, :float
  end
end
