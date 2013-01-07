source :gemcutter

gem "rails", "2.3.8"
gem "rack", "~> 1.1.0"

gem "inherited_resources", "= 1.0.6"
gem "will_paginate", "~> 2.3.11"
gem "SyslogLogger"
gem "delayed_job"
gem "taglib-ruby"
gem "eventmachine"
gem "strip_attributes"

gem "pige", :git => "git://projects.tryphon.priv/pige"

group :development, :test do
  # To use eventmachine debian package
  gem "capistrano"
  gem "capistrano-ext"
end

group :development do
  gem "sqlite3-ruby"
  gem "less"
  gem "rake-debian-build"
  gem "autotest"
  gem "autotest-notification"
  gem "guard"
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-cucumber'
end

group :test do
  gem "factory_girl"
  gem 'rspec', '= 1.3.1'
  gem 'rspec-rails', '= 1.3.3'
  gem 'remarkable_rails'
  gem "markup_validity"
  gem "rcov"
  
  # Requires to run spec:plugins
  gem "metalive"
end

group :cucumber do
  gem 'webrat'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'rspec-rails', '= 1.3.3'
  gem 'pickle'
  gem 'factory_girl'
end
