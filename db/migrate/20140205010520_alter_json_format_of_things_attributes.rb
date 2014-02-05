class AlterJsonFormatOfThingsAttributes < ActiveRecord::Migration
  def up
    Thing.find_each do |thing|
      begin
        atts = thing.general_attributes.dup
        thing.general_attributes = {}
        atts.each do |att| 
          thing.general_attributes[att.keys.first] ||= []
          thing.general_attributes[att.keys.first] << att[att.keys.first]
        end 
        thing.save!
      rescue Exception => e
        puts "Warning: Attribute not transformed #{e.message}"
      end
    end 
  end

  def down
    Thing.find_each do |thing|
      begin
        atts = thing.general_attributes.dup
        thing.general_attributes = []
        atts.each do |key, value_list| 
          value_list.each do |val|
            thing.general_attributes << {key => val}
          end
        end 
        thing.save!
      rescue Exception => e
        puts "Warning: Attribute not transformed #{e.message}"
      end
    end 
  end
end
