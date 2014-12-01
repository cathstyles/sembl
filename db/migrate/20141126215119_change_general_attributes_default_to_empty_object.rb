# Use a naked class so that we don't get errors when `Thing.filter_keys` is
# run inside of its `searchable` block. Before this migration is run,
# `.filter_keys` will return errors, since it depends on all things having
# `{}` as the defalut value for general_attributes.
class BareThing < ActiveRecord::Base
  self.table_name = "things"
end

class ChangeGeneralAttributesDefaultToEmptyObject < ActiveRecord::Migration
  def up
    # Convert all the empty array attributes (the previous default) to empty objects (the new default)
    Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new
    BareThing.find_each do |thing|
      if thing.general_attributes.blank?
        thing.update_attribute :general_attributes, {}
      end
    end

    # Set the new default
    change_column :things, :general_attributes, :json, default: '{}', null: false
  end

  def down
    change_column :things, :general_attributes, :json, default: '[]'
  end
end
