require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  storage :fog

  process :set_content_type

  def store_dir
    "uploads/#{model.class.model_name.collection}/#{model.id}/#{mounted_as}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:admin_thumb) do
    process resize_to_fill: [150, 150]
  end

  version(:browse_thumb) do 
    process resize_to_fit: [100000, 350]
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension.downcase}" if original_filename
  end

  def store_dir
    "images/#{model.id}"
  end


  private

  def secure_token
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end
