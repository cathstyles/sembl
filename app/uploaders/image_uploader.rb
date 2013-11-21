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
end
