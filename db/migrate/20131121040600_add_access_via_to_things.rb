class AddAccessViaToThings < ActiveRecord::Migration
  def change
    add_column :things, :access_via, :string
  end
end
