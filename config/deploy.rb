require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/bundler'
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'pdf_api'
set :domain, 'roccia@125.208.9.73'
set :deploy_to, '/home/roccia/pdf_api'
set :repository, 'https://github.com/roccia/pdf_api.git'
set :branch, 'master'

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# set :shared_dirs, fetch(:shared_dirs, []).push('somedir')
#set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
# 中括号里的文件 会出现在服务器项目附录的shared文件夹中，这里加入了secrets.yml，环境密钥无需跟开发计算机一样
set :shared_paths, ['config/database.yml', 'log', 'config/secrets.yml']

# 这个块里面的代码表示运行 mina setup时运行的命令
task :setup => :environment do

  # 在服务器项目目录的shared中创建log文件夹
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  # 在服务器项目目录的shared中创建config文件夹 下同
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]

  # puma.rb 配置puma必须得文件夹及文件
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/sockets"]

  queue! %[touch "#{deploy_to}/shared/config/puma.rb"]
  queue  %[echo "-----> Be sure to edit 'shared/config/puma.rb'."]

  # tmp/sockets/puma.state
  queue! %[touch "#{deploy_to}/shared/tmp/sockets/puma.state"]
  queue  %[echo "-----> Be sure to edit 'shared/tmp/sockets/puma.state'."]

  # log/puma.stdout.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stdout.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stdout.log'."]

  # log/puma.stdout.log
  queue! %[touch "#{deploy_to}/shared/log/puma.stderr.log"]
  queue  %[echo "-----> Be sure to edit 'shared/log/puma.stderr.log'."]

  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]
end

#这个代码块表示运行 mina deploy时执行的命令
desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
  end
  deploy do
    #重新拉git服务器上的最新版本，即使没有改变
    invoke :'git:clone'
    #重新设定shared_path位置
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      # queue "chown -R www-data #{deploy_to}"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
    end
  end
end