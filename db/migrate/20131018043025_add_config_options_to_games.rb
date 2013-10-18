class AddConfigOptionsToGames < ActiveRecord::Migration
  def change
    add_column :games, :invite_only, :boolean, default: false
    add_column :games, :uploads_allowed, :boolean, default: false
    add_column :games, :theme, :string
    add_column :games, :filter_content_by, :text
    add_column :games, :allow_keyword_search, :boolean, default: false
  end
end
