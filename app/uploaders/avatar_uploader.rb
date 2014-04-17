require 'carrierwave/processing/mime_types'

# TODO: user carrierwave backgrounder to move image processing into a background task.
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  include CarrierWave::MiniMagick

  process :set_content_type

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  version(:thumb) do
    process resize_to_fill: [150, 150]
  end

  version(:tiny_thumb) do
    process resize_to_fit: [40, 40]
  end

  def filename
    @name ||= "#{secure_token}.#{file.extension.downcase}" if original_filename
  end


private

  def secure_token
    ivar = "@#{mounted_as}_secure_token"
    token = model.instance_variable_get(ivar)
    token ||= model.instance_variable_set(ivar, SecureRandom.hex(4))
  end
end
