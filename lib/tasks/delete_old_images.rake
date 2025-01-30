namespace :images do
  desc "Delete images older than 1 year"
  task delete_old: :environment do
    # 1年以上前に作成された画像を取得
    old_images = Image.where('created_at <= ?', 1.day.ago)

    old_images.find_each do |image|
      begin
        # レコードを削除（CarrierWaveでCloudinaryの画像も削除）
        image.destroy
        puts "Deleted database record and associated Cloudinary image for image ID: #{image.id}"
      rescue => e
        puts "Error deleting image ID #{image.id}: #{e.message}"
      end
    end

    puts "Completed deleting old images."
  end
end
