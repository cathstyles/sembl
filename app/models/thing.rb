# == Schema Information
#
# Table name: things
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  description        :text             default("")
#  creator_id         :integer
#  updator_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  image              :string(255)
#  attribution        :string(255)
#  item_url           :string(255)
#  copyright          :string(255)
#  general_attributes :json             default([]), not null
#  import_row_id      :string(255)
#  random_seed        :string(255)
#  access_via         :string(255)
#

class Thing < ActiveRecord::Base
  validates :image, presence: true

  belongs_to :creator, class_name: "User"
  belongs_to :updator, class_name: "User"

  mount_uploader :image, ImageUploader

  def self.import_csv(filename, options = {})
    default_options = {
      image_path: File.dirname(filename),
      remote: true
    }

    options.reverse_merge!(default_options)

    # Map csv field names to thing attributes
    # Anything unmapped goes into :general_attributes
    
    csv_processor = ProcessCSV.new(filename, field_mapping, remote: options[:remote])

    #TODO, remove this once we have import_row_id's and only update/add new
    self.delete_all

    csv_processor.foreach do |row|
      begin
        self.create_thing_from_row(row, options)
      rescue Exception => e
        puts "Error loading file #{row[:image_filename]}: #{e.message}"
      end
    end 
  end

  private 

  def self.create_thing_from_row(row, options)
    image_filename = row.delete(:image_filename)
    image_url = row.delete(:image_url)

    # Ignore row if there is no image
    return unless image_filename.present? || image_url.present?

    thing = self.new
    image_path = image_url || File.join(options[:image_path], image_filename)

    if options[:remote] || image_url.present?
      thing.remote_image_url = image_path
    else 
      thing.image = File.open(image_path)
    end

    thing.random_seed = SecureRandom.hex(8)
    thing.update(row)
    thing.save!
  end

  def self.field_mapping 
    {
      'Row ID' => :import_row_id,
      'Filename' => :image_filename, 
      'Image URL' => :image_url,
      'Attribution' => :attribution, 
      'URL for context' => :item_url, 
      'Alt tag' => :description, 
      'Access via' => :access_via, 
      'Copyright info' => :copyright 
    }
  end

end

