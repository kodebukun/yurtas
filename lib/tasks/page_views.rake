namespace :page_views do
  desc "90日以上前の閲覧履歴を削除"
  task cleanup: :environment do
    deleted = PageView.where("updated_at < ?", 180.days.ago).delete_all
    puts "#{deleted}件削除しました"
  end
end
