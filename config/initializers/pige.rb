require 'pige'

Pigecontrol::Application.config.to_prepare do
  Sox.logger = Rails.logger
end
