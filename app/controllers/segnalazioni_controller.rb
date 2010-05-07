class SegnalazioniController < ApplicationController

	respond_to :html, :xml, :json
	before_filter :require_user

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

end
