class ChangeFilterContentByOnGames < ActiveRecord::Migration
  def up
    add_column :games, :filter_content_by_tmp, :json

    Game.reset_column_information
    Game.find_each do |game|
      if game.filter_content_by.present?
        game.filter_content_by_tmp = ['Keywords' => game.filter_content_by]
        game.save
      end
    end

    remove_column :games, :filter_content_by
    rename_column :games, :filter_content_by_tmp, :filter_content_by
  end

  def down 
    add_column :games, :filter_content_by_tmp, :text, null: false, default: ""

    Game.reset_column_information
    Game.find_each do |game|
      game.filter_content_by_tmp = game.filter_content_by.to_s
      game.save
    end

    remove_column :games, :filter_content_by
    rename_column :games, :filter_content_by_tmp, :filter_content_by
  end
end
