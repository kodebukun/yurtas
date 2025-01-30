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
