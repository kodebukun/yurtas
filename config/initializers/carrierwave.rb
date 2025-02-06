CarrierWave.configure do |config|
  if Rails.env.production?
    config.asset_host = "https://res.cloudinary.com/deptc6awq"
  else
    config.asset_host = "http://localhost:3000"
  end
end
