begin
  require 'debian/build'

  include Debian::Build
  require 'debian/build/config'

  namespace "package" do
    Package.new(:pige) do |t|
      t.version = '0.6'
      t.debian_increment = 1

      t.source_provider = GitExportProvider.new do |source_directory|
        %w{user_interface boxcontrol user_voice}.each do |submodule|
          Dir.chdir("vendor/plugins/#{submodule}") do 
            sh "git archive --prefix=vendor/plugins/#{submodule}/ HEAD | tar -xf - -C #{source_directory}"      
          end
        end
      end
    end
  end

  require 'debian/build/tasks'
rescue Exception => e
  puts "WARNING: Can't load debian package tasks (#{e.to_s})"
end
