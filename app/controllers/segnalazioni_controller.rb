class SegnalazioniController < ApplicationController
  layout "application", :except => :gsprg
  respond_to :html, :xml, :json, :rdf
  before_filter :require_user, :except => [:show, :gsprg]
  
  # POST /segnalazioni
  # POST /segnalazioni.xml
  def create
    @segnalazione = Segnalazione.new(params[:segnalazione])
    respond_to do |format|
      if @segnalazione.save
        format.html { redirect_to(@segnalazione, :notice => 'Segnalazione inserita con successo.') }
        format.xml  { render :xml => @segnalazione, :status => :created, :location => @segnalazione }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @segnalazione.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show 
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    respond_with @segnalazione 
  end
  
  def update
    nuova_des = params[:s][:des_segna]
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    old_des = @segnalazione.des_segna
    @segnalazione.des_segna = nuova_des
    if(@segnalazione.save)
      SegnalazioniMailer.cambio_descrizione(current_user, @segnalazione, old_des).deliver  
      flash[:notice] = "Segnalazione #{@segnalazione.prg_segna} aggiornata con successo!"
    else 
      flash[:error] = "Aggiornamento fallito!"
    end
    respond_to do |format|
      format.html { }
      format.js {
      }
    end
  end
  
  def index
    @segnalazioni = Segnalazione.risolutore(current_user.user_name)
    respond_to do |format|
      format.html {
        respond_with @segnalazioni
      }
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end
  
  def gsprg
    gs = request.GET[:q]
    user_id = request.GET[:user_id]
    @gs = Segnalazione.select(:prg_segna).where("prg_segna LIKE '#{gs}%'").limit(request.GET[:limit])
    unless user_id == '-1' 
      @gs = @gs.involved(user_id)
    end
    @gs = @gs.collect{|g| g.prg_segna}
    puts "GS recuperate: #{@gs}"
    respond_with @gs
  end
  
  # GET /segnalazioni/new
  # GET /segnalazioni/new.xml
  def new
    @segnalazione = Segnalazione.new
    @segnalazione.dtm_creaz = Date.today
    respond_with @segnalazione
  end
  
  # GET /segnalazioni/1/edit
  def edit
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    respond_with(@segnalazione)
  end
  
  # DELETE /segnalazioni/1
  # DELETE /segnalazioni/1.xml
  def destroy
    @utente = Segnalazione.find_by_prg_segna(params[:id])
    @utente.destroy
    
    respond_to do |format|
      format.html { redirect_to(segnalazioni_url) }
      format.xml  { head :ok }
    end
  end
end
