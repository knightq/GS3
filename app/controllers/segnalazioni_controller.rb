class SegnalazioniController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :require_user

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
		prg_segna = params[:id]
		puts "====================== PRESA IN CARICO! #{prg_segna}======================"
    respond_to do |format|
      format.html { }
			format.js {
				puts "====================== RJS!!!! ======================"
			
			 }
    end
  end

  def index
		@segnalazioni = Segnalazione.risolutore(current_user.user_name)
		respond_with @segnalazioni
  rescue ActiveRecord::RecordNotFound
    render_404
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
