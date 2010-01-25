set :application, "pige"

set :repository,  "git://projects.tryphon.eu/pige"
set :scm, :git
set :git_enable_submodules, true
set :deploy_via, :copy

set :deploy_to, "/var/www/pige"

role :web, "radio.dbx.tryphon.priv"
role :app, "radio.dbx.tryphon.priv"
role :db,  "radio.dbx.tryphon.priv", :primary => true

# after "deploy:setup", "db:create"

set :keep_releases, 10
after "deploy:update", "deploy:cleanup" 
set :use_sudo, false

after "deploy:update_code", "deploy:symlink_shared", "deploy:gems"
after "deploy:migrations", "deploy:fix_db_permissions"

namespace :deploy do
  # Prevent errors when chmod isn't allowed by server
  task :setup, :except => { :no_release => true } do
    dirs = [deploy_to, releases_path, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "mkdir -p #{dirs.join(' ')} && (chmod g+w #{dirs.join(' ')} || true)"
  end

  desc "Symlinks shared configs and folders on each release"
  task :symlink_shared, :except => { :no_release => true }  do
    run "ln -nfs #{shared_path}/config/database.yml #{shared_path}/config/production.rb #{release_path}/config/"
  end

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Install gems"
  task :gems, :roles => :app do
    sudo "rake --rakefile=#{release_path}/Rakefile gems:install RAILS_ENV=production"
  end

  desc "Fix database file permissions"
  task :fix_db_permissions, :roles => :db do
    sudo "chown www-data:src #{shared_path}/db/production.sqlite3"
    sudo "chmod g+w #{shared_path}/db/production.sqlite3"
  end

end
