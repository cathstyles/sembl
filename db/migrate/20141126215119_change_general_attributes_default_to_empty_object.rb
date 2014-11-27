class ChangeGeneralAttributesDefaultToEmptyObject < ActiveRecord::Migration
  def up
    # Convert all the empty array attributes (the previous default) to empty objects (the new default)
    Sunspot.session = Sunspot::SessionProxy::SilentFailSessionProxy.new #(Sunspot.session)
    Thing.find_each do |thing|
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
