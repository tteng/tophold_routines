require 'capistrano/ext/multistage'
require "whenever/capistrano"

set :repository,  "http://sourceserver/svn/frontend/pub/itools"
set :scm, :subversion
set :use_sudo, false
set :rake, "/usr/local/bin/rake"
set :whenever, "/usr/local/ruby/bin/whenever"
#set :rails_env, "production"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :stages, %w{default}
set :default_stage, "default"

set :scm_username, "somename"
set :scm_password, "pwd"
set :deploy_via,   :copy

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

 namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end

end

namespace :bundle do
  desc "run bundle install and ensure all gem requirements are met"
  task :install do
    run "cd #{current_path} && bundle install  --without=test"
  end
end

before "deploy:restart", "bundle:install"

before "deploy:assets:precompile" do
  run "rm #{release_path}/config/database.yml"
  run "ln -s #{deploy_to}/#{shared_dir}/database.yml #{release_path}/config/database.yml"
end

