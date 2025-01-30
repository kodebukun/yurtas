# lib/tasks/carrierwave_cleanup.rake
namespace :carrierwave do
  desc "Clean up old cached files in CarrierWave"
  task clean_cached_files: :environment do
    CarrierWave.clean_cached_files!
    puts "CarrierWave: Old cached files cleaned up!"
  end
end
