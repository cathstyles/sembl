class ChangeNameOfLinkDescriptionColumn < ActiveRecord::Migration
  def change
    rename_column :resemblances, :link_description, :source_description
  end
end
