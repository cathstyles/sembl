CarrierWave.configure do |config|
  config.storage = :fog
  config.store_dir = lambda { |uploader| "#{uploader.model.class.model_name.collection}/#{uploader.model.id}/#{uploader.mounted_as}" }

  # S3 + CloudFront settings
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["AWS_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"],
    region: ENV["FOG_REGION"]
  }
  config.fog_directory  = ENV["FOG_DIRECTORY"]
  config.fog_public = true
  config.fog_attributes = {
    "Cache-Control" => "max-age=4838400, public",
    "Expires" => 10.years.from_now.httpdate
  }

  if ENV["CLOUDFRONT_DOMAIN"].present?
    config.asset_host = "https://#{ENV['CLOUDFRONT_DOMAIN']}"
  end

  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.asset_host = "http://localhost:3000"
  end
end
