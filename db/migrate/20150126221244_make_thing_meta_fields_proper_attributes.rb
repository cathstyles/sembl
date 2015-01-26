class MakeThingMetaFieldsProperAttributes < ActiveRecord::Migration
  def up
    add_column :things, :dates, :string
    add_column :things, :keywords, :string
    add_column :things, :places, :string
    add_column :things, :node_type, :string

    puts "Migrating data from general attributes"
    Thing.find_each do |thing|
      # Dates
      dates = thing.general_attributes["Date/s"]
      thing.dates = dates.join(", ") if dates
      # Keywords
      keywords = thing.general_attributes["Keywords"]
      thing.keywords = keywords.join(", ") if keywords
      # Places
      places = thing.general_attributes["Places"]
      thing.places = places.join(", ") if places
      # Node type
      node_types = thing.general_attributes["Node type"]
      thing.node_type = node_types.join(", ") if node_types
      thing.save!
    end
  end

  def down
    # no operation required
  end
end
