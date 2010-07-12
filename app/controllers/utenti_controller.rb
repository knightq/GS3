class UtentiController < ApplicationController

	respond_to :html, :xml, :json, :js
  before_filter :require_user#, :only => [:show, :edit, :update]

  # GET /utenti
  # GET /utenti.xml
  def index
    @utenti = Utente.scoped
    @utenti = @utenti.where('user_name LIKE ?', "%#{params[:q].upcase}%") if params[:q]  
    @utenti = @utenti.attivi.exclude_uni.includes(:recapito).order('USER_NAME asc')
		@utenti_group = @utenti.to_a.group_by{ |u| u.user_name.to_s[0..0].upcase }  
		#respond_with(@utenti)
  end

  # GET /utenti/1
  # GET /utenti/1.xml
  def show
    @utente = Utente.find(params[:id])
		respond_with(@utente)
  end

  # GET /utenti/new
  # GET /utenti/new.xml
  def new
    @utente = Utente.new
		respond_with(@utente)
  end

  # GET /utenti/1/edit
  def edit
    @utente = Utente.find(params[:id])
		respond_with(@utente)
  end

  # POST /utenti
  # POST /utenti.xml
  def create
    @utente = Utente.new(params[:utente])

    respond_to do |format|
      if @utente.save
        flash[:notice] = 'Utente was successfully created.'
        format.html { redirect_to(@utente) }
        format.xml  { render :xml => @utente, :status => :created, :location => @utente }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @utente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /utenti/1
  # PUT /utenti/1.xml
  def update
    @utente = Utente.find(params[:id])

    respond_to do |format|
      if @utente.update_attributes(params[:utente])
        flash[:notice] = 'Utente was successfully updated.'
        format.html { redirect_to(@utente) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @utente.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /utenti/1
  # DELETE /utenti/1.xml
  def destroy
    @utente = Utente.find(params[:id])
    @utente.destroy

    respond_to do |format|
      format.html { redirect_to(utenti_url) }
      format.xml  { head :ok }
    end
  end

end
