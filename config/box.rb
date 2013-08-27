# if defined?(Rails)
#   Box.logger = Rails.logger
# else
#   require 'logger'
#   Box.logger = Logger.new("log/box.log")
# end

# Use explicitly ruby1.8 (instead of 'env ruby')
unless Box.executable.start_with?("/usr/bin/ruby1.8")
  Box.executable = "/usr/bin/ruby1.8 #{Box.executable}"
end

Box::Release.latest_url = "http://dev.tryphon.priv/dist/pigebox/latest.yml"
Box::Release.current_url = "public/current.yml"
Box::Release.install_command = "/bin/true"

# Use this script to initialize Box commands executed in background
Box.start_default_options = { :config => __FILE__ }
