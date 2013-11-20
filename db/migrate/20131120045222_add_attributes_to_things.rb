class AddAttributesToThings < ActiveRecord::Migration
  def change
    add_column :things, :attribution, :string 
    add_column :things, :item_url, :string
    add_column :things, :copyright, :string
    add_column :things, :attributes, :json, null: false, default: "[]"
    change_column :things, :title, :string, null: true
  end
end
