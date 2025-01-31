# config valid only for current version of Capistrano

lock "~> 3.19.2" # Capistranoのバージョン

set :application, 'yurtas' # アプリケーション名
set :repo_url, 'https://github.com/kodebukun/yurtas' # クローンするGitHubリポジトリ（xxxxはユーザ名、yyyyはアプリ名）
set :deploy_to, '/var/www/yurtas' # デプロイ先のディレクトリ
set :linked_files, %w{.env config/secrets.yml} # シンボリックリンクを貼るファイル
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/uploads public/storage public/attendances_pdf} # シンボリックリンクを貼るディレクトリ
set :keep_releases, 3 # 保持するバージョンの数
set :rbenv_ruby, '2.6.6' # Rubyのバージョン
set :rbenv_type, :system
set :log_level, :debug # 出力するログのレベル 概要レベルにしたければ :info とする
set :rails_env, 'production'

set :default_env, {
  'RAILS_ENV' => 'production',
  'CLOUDINARY_CLOUD_NAME' => ENV['CLOUDINARY_CLOUD_NAME'],
  'CLOUDINARY_API_KEY' => ENV['CLOUDINARY_API_KEY'],
  'CLOUDINARY_API_SECRET' => ENV['CLOUDINARY_API_SECRET']
}

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end
  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rails, 'db:create'
        end
      end
    end
  end
  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rails, 'db:seed'
        end
      end
    end
  end
  after :publishing, :restart
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

namespace :deploy do
  desc 'Precompile assets locally and upload to servers'
  task :precompile do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'assets:precompile'
        end
      end
    end
  end

  before 'deploy:restart', 'deploy:precompile'
end
