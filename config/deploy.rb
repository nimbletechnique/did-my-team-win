require 'mongrel_cluster/recipes'

set :application, "didmyteamwintoday"
set :user, "deploy"
set :host, "#{user}@gluedtomyseat.com"
set :use_sudo, false

set :scm, :git
set :repository, "git@github.com:oculardisaster/did-my-team-win.git"

set :deploy_to, "/var/www/apps/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :runner, user
set :ssh_options, { :forward_agent => true }
set :branch, "master"

role :app, "#{host}"
role :web, "#{host}"
role :db,  "#{host}", :primary => true

after 'deploy:symlink' do
  run "cp #{deploy_to}/shared/database.yml #{deploy_to}/current/config"
  run "cp #{deploy_to}/shared/mongrel_cluster.yml #{deploy_to}/current/config"
end

