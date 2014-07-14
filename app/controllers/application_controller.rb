class ApplicationController < ActionController::Base
  protect_from_forgery

  include UserInterface::LocaleManagement
  include UserInterface::UserSessionManagement

  protected

  def user_session(defaults = {})
    @user_session ||= UserSession.new session, :language => accepted_language
  end
end
