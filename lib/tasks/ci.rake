namespace :ci do
  desc "Prepare CI build"
  task :setup do
    unless uptodate?("config/database.yml", "config/database.yml.sample") 
      cp "config/database.yml.sample", "config/database.yml" 
    end
  end
end

desc "Run continuous integration tasks (spec, ...)"
task :ci => ["ci:setup", "db:migrate", "db:test:prepare", "spec", "spec:plugins", "cucumber"]
