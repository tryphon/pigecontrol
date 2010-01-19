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

begin
  require 'debian/build'

  include Debian::Build
  require 'debian/build/config'

  namespace "package" do
    Package.new(:pige) do |t|
      t.version = '0.1'
      t.debian_increment = 1

      t.source_provider = GitExportProvider.new do |source_directory|
        Dir.chdir("vendor/plugins/user_interface") do 
          sh "git archive --prefix=vendor/plugins/user_interface/ HEAD | tar -xf - -C #{source_directory}"      
        end
      end
    end
  end

  require 'debian/build/tasks'
rescue Exception => e
  puts "WARNING: Can't load debian package tasks (#{e.to_s})"
end
