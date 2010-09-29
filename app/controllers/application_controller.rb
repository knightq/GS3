# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout 'application' #Rails 3
  before_filter :save_origin_url, :only => :show

	attr_accessor :funzione

  # Scrub sensitive parameters from your log
  helper_method :current_user_session, :current_user

	def initialize
		super()
		@funzione = Funzione.new
	end

  def require_user
    unless current_user
      #store_location
      flash[:notice] = "Devi essere autenticato per accedere a questa pagina"
      redirect_to home_path
      return false
    end
  end

  def require_no_user
    if current_user
      #store_location
      flash[:notice] = "Non devi essere autenticato per accedere a questa pagina"
      redirect_to home_path
      return false
    end
  end

	def redirect_back_or_default(default)
		redirect_to(session[:return_to] || default)
		session[:return_to] = nil
	end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user ||= current_user_session && current_user_session.utente
    session[:user] = @current_user
    session[:user]
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def esci
    @current_user_session = nil
    redirect_to home_path
  end

  def save_origin_url
    @origin_url = request.referer
  end

end
