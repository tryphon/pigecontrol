# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'

$: << "#{File.dirname(__FILE__)}/vendor/plugins/user_interface/lib"
require 'user_interface/tasks'

UserInterface::Tasks::Css.new :stylesheet, :color => "#1273b4", :logo => 'pigebox'
UserInterface::Tasks::Install.new :logo => 'pigebox'
