require 'carrierwave/processing/mime_types'

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  process :set_content_type

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:admin_thumb) do
    process resize_to_fill: [150, 150]
  end

  version(:browse_thumb) do
    process resize_to_fit: [1000, 350]
  end

  version(:large) do
    process resize_to_fit: [1200, 1200]
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension.downcase}" if original_filename
  end

  # These two methods are for our specs so images are stored locally
  if Rails.env.test? || Rails.env.cucumber?
    def cache_dir
      "#{Rails.root}/public/uploads/tmp"
    end

    def store_dir
      "#{Rails.root}/public/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end

private

  def secure_token
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end
