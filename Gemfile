source 'https://rubygems.org'

gem "rails", "2.3.8"
gem "rack", "~> 1.1.0"

gem "inherited_resources", "= 1.0.6"
gem "will_paginate", "~> 2.3.11"
gem "SyslogLogger"
gem "delayed_job"
gem "eventmachine"
gem "strip_attributes"

gem "pige", :git => "git://projects.tryphon.priv/pige"
# TagLib 0.5.0 requires tagc0 1.7
gem "taglib-ruby", "~> 0.4.0"

# Requires to run spec:plugins
gem "metalive"

gem "tryphon-box", :git => "git://projects.tryphon.priv/box"

group :development, :test do
  # To use eventmachine debian package
  gem "capistrano"
  gem "capistrano-ext"
end

group :development do
  gem "sqlite3-ruby"
  gem "less"
  gem "rake-debian-build"
end

group :development, :test do
  gem "guard"
  gem 'guard-rspec'
  gem 'guard-bundler'
  gem 'guard-cucumber'
  gem 'launchy'
end

group :test do
  gem "factory_girl"
  gem 'rspec', '= 1.3.1'
  gem 'rspec-rails', '= 1.3.3'
  gem 'remarkable_rails'
  gem "markup_validity"
  gem "rcov"
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
