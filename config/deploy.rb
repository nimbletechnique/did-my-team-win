set :application, "didmyteamwintoday"
set :user, "deploy"
set :host, "#{user}@gluedtomyseat.com"

set :scm, :git
set :repository, "git@github.com:oculardisaster/did-my-team-win.git"

set :deploy_to, "/var/www/apps/#{application}"
set :runner, user
set :ssh_options, { :forward_agent => true }
set :branch, "master"

role :app, "#{host}"
role :web, "#{host}"
role :db,  "#{host}", :primary => true

after 'deploy:symlink' do
  run "cp #{deploy_to}/shared/database.yml #{deploy_to}/current/config"
end

after "deploy" do
  run "RAILS_ENV=production #{current_path}/script/fetch_scores"
end
