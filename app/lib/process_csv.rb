class ProcessCSV
  attr_accessor :filename, :map, :options

  require 'csv'

  def initialize(filename, map = {})
    @filename = filename
    @options = options
    @map = map 

  end

  def foreach
    CSV.foreach(filename, headers: true) do |row|
      out = {general_attributes: []}
      row.each do |key, value|
        mapped_key = map[key.strip] 

        if mapped_key
          out[mapped_key] = value  
        else 
          # key not mapped, add to general attributes
          values = value.try(:split, ',') || []
          values.each do |val|
            out[:general_attributes] << {key => val.strip}
          end
        end
      end
      yield out
    end
  end

end