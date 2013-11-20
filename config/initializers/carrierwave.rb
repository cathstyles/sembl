CarrierWave.configure do |config|
  # S3 + CloudFront settings
  config.fog_credentials = {
    provider: "AWS",
    aws_access_key_id: ENV["UPLOADER_S3_ACCESS_KEY_ID"],
    aws_secret_access_key: ENV["UPLOADER_S3_SECRET_ACCESS_KEY"],
    region: ENV["UPLOADER_S3_REGION"]
  }
  config.fog_directory  = ENV["UPLOADER_S3_BUCKET"]
  config.fog_public = true
  config.fog_attributes = {
    "Cache-Control" => "max-age=4838400, public",
    "Expires" => 10.years.from_now.httpdate
  }
  if ENV["CLOUD_FRONT_DOMAIN"].present?
    config.asset_host = "https://#{ENV['CLOUD_FRONT_DOMAIN']}"
  end
end
