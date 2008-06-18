set :application, "didmyteamwin"
set :user, "collin"
set :host, "#{user}@gluedtomyseat.com"

set :scm, :git
set :repository, "git@github.com:oculardisaster/did-my-team-win.git"

set :deploy_to, "/home/#{user}/web/rails/#{application}"
set :runner, user
set :ssh_options, { :forward_agent => true }
set :branch, "master"

role :app, "#{host}"
role :web, "#{host}"
role :db,  "#{host}", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

after 'deploy:symlink' do
  run "cp #{deploy_to}/shared/database.yml #{deploy_to}/current/config"
end

after "deploy" do
  run "#{current_path}/script/fetch_scores"
end
