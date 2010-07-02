class UserSessionsController < ApplicationController
  #before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    if current_user_session
      redirect_to todo_path
    else
      @user_session = UserSession.new
    end
    
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
#    if @user_session.valid?
      if @user_session.save
        flash[:notice] = "Autenticato con successo!"
        redirect_back_or_default '/todo'
      else
        flash[:error] = "Credenziali errate!"
        #render :action => :new
        redirect_to home_path
      end
#    else
#        flash[:error] = "Errori di validazione!"
        #render :action => :new
#        redirect_to home_path      
#    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Disconnesso!"
    redirect_to home_path
  end

end
