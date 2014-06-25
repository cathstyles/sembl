class AddLinkDescriptionsToResemblances < ActiveRecord::Migration
  def change
    add_column :resemblances, :link_description, :text
    add_column :resemblances, :target_description, :text
  end
end
