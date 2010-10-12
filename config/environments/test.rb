# Settings specified here will take precedence over those in config/environment.rb

# The test environment is used exclusively to run your application's
# test suite.  You never need to work with it otherwise.  Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs.  Don't rely on the data there!
config.cache_classes = true

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false

# Disable request forgery protection in test environment
config.action_controller.allow_forgery_protection    = false

# Tell Action Mailer not to deliver emails to the real world.
# The :test delivery method accumulates sent emails in the
# ActionMailer::Base.deliveries array.
config.action_mailer.delivery_method = :test

config.gem "rspec",            :lib => false
config.gem "rspec-rails",      :lib => false
config.gem "factory_girl",     :source => "http://gemcutter.org"
config.gem "remarkable_rails", :lib => false

config.after_initialize do
  def Chunk.test_storage_directory
    "#{Rails.root}/tmp/chunks_test"
  end
  Chunk.storage_directory = Chunk.test_storage_directory
end
