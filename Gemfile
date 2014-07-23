source 'https://rubygems.org'

gem 'rails', '~> 3.2.17'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3'

gem 'user_interface', :git => 'git://projects.tryphon.priv/user-interface', :branch => 'rails3' #, :path => "~/Projects/UserInterface"
gem 'boxcontrol', :git => 'git://projects.tryphon.priv/boxcontrol', :branch => 'rails3', :require => 'box_control' #, :path => "~/Projects/BoxControl"
gem 'tryphon-box', :git => 'git://projects.tryphon.priv/box'#, :path => "~/Projects/Box"
gem 'inherited_resources'

gem 'rails-i18n'
gem "SyslogLogger", "~> 2.0", :require => "syslog/logger"

gem 'will_paginate'
gem 'delayed_job_active_record'
gem "eventmachine"
gem "pige", :git => "git://projects.tryphon.priv/pige"
gem "taglib-ruby"

gem 'audiobank-client', :git => 'git://projects.tryphon.priv/audiobank-client', :path => "~/Projects/AudioBankClient"
gem 'parallel'
gem 'listen'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

group :test, :development do
  gem "rspec-rails", "~> 2.4"
  gem "capybara"

  gem "factory_girl"
  gem "shoulda-matchers"
  gem "markup_validity", :require => false
  gem 'fake_ftp'

  gem "guard"
  gem "guard-rspec"
  gem "guard-bundler"
  gem "guard-cucumber"
  gem "rb-inotify"
  gem 'libnotify'

  gem "brakeman", :require => false
  gem "jasminerice", :git => 'https://github.com/bradphelan/jasminerice.git'

  gem 'simplecov'
  gem 'simplecov-rcov'
end
