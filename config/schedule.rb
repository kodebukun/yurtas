# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# ログの出力先
set :output, "log/cron_log.log"
# 実行環境を設定
set :environment, "production"

# 毎日午前0時にキャッシュされたファイルをクリーンアップ
every 1.day, at: '12:00 am' do
  rake "carrierwave:clean_cached_files"
end

# 毎月1日の午前2時に1年以上前の画像を削除
every '0 2 1 * *' do
  rake "images:delete_old"
end

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
