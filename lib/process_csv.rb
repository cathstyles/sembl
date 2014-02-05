class ProcessCSV
  attr_accessor :filepath, :map, :options

  require 'csv'
  require 'open-uri'

  def initialize(filepath, map = {}, options = {})
    @options = options.reverse_merge!(remote: true)
    @map = map 
    @filepath = filepath
  end

  def foreach(&block)
    options[:remote] ? parse_remote(&block) : parse_local(&block)
  end

  private

  def parse_remote(&block)
   open(@filepath) do |file|
      CSV.parse(file, headers: true) do |row|
        block.call process_row(row)
      end
    end
  end

  def parse_local(&block)
    CSV.foreach(@filepath, headers: true) do |row|
      block.call process_row(row)
    end
  end

  def process_row(row)
    out = {general_attributes: {}}
    row.each do |key, value|

      mapped_key = map[key.try(:strip)] 

      if mapped_key
        out[mapped_key] = value  
      else 
        # key not mapped, add to general attributes
        values = value.try(:split, ',') || []
        out[:general_attributes][key] = values.map(&:strip)
      end
    end
    out
  end

end