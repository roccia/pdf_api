# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "pdf_api"
set :repo_url, "git@github.com:roccia/pdf_api.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/roccia/pdf_api"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :pty,  false
# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5


namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :restart, :restart_sidekiq do
    on roles(:sidekiq), in: :groups, limit: 3, wait: 1 do
      pid_file = '/data/meiweb/current/tmp/pids/sidekiq-0.pid'
      execute "if [ -f #{pid_file} ] && ps -p `cat #{pid_file}`; then kill -TERM `cat #{pid_file}`; fi"
    end
  end

end
