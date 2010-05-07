class TodoController < ApplicationController
	respond_to :html, :xml, :json, :js
	before_filter :require_user

	def index
		if request.format.js?
			puts "REQUEST JS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		else
			puts "REQUEST HTML!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
			puts "======"
			puts "#{request.format}"
			puts "======"
			@todo ||= TodoQuery.new('AS')
			@segnalazioni = @todo.filtra(Segnalazione.risolutore(current_user.user_name))
			@prodotti = @segnalazioni.to_a.group_by(&:cda_prodotto)
			risolte_ultimo_mese = Segnalazione.risolte_ultimo_mese(current_user.user_name)
			@statistica = Statistica.new(risolte_ultimo_mese.size, risolte_ultimo_mese.each.inject(0) { |sum, el| sum = sum + el.tempo_risol_impiegato })
			respond_with @prodotti
#	  respond_to do |format|
#      format.html {	render :html => @prodotti }
#      format.js
#    end		
		end
	end

	def update
		prg_segna = params[:id]
		puts "====================== PRESA IN CARICO! #{prg_segna}======================"
    respond_with()
  end

	def filter_update
    respond_to do |format|
      format.js {
				render :js => @todo
			}
    end		
	end

  # POST /todo
  # POST /todo.rjs
  def create
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    puts "SONO IO!! IOOOOOOOO!!!"
    respond_to do |format|
       format.js
    end
  end

end
