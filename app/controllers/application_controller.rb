# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '159581b58a766ec04a2103d0611b9323'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  include UserInterface::LocaleManagement
  include UserInterface::UserSessionManagement

  protected

  def user_session(defaults = {})
    @user_session ||= UserSession.new session, :language => accepted_language
  end

end
