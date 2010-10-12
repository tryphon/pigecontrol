$: << "#{File.dirname(__FILE__)}/../../vendor/plugins/user_interface/lib"
require 'user_interface/tasks'

UserInterface::Tasks::Css.new :stylesheet, :color => "#1273b4", :logo => 'pigebox'
UserInterface::Tasks::Install.new :logo => 'pigebox'
