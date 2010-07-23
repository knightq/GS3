class TodoController < ApplicationController
  respond_to :html, :xml, :json, :js
  
  before_filter :require_user
  
  def index
    @todo ||= TodoQuery.new('AS')
    #@segnalazioni = @todo.filtra(Segnalazione.risolutore(current_user.user_name))
    segnalazioni = Segnalazione.find_by_user_todo(current_user.user_name).order('cda_prodotto ASC')
    @prodotti = segnalazioni.to_a.group_by(&:cda_prodotto).sort {|a,b| a[0]<=>b[0]}
    @in_carico = segnalazioni.in_consegna
    risolte_ultimo_mese = Segnalazione.risolte_ultimo_mese(current_user.user_name)
    @statistica = Statistica.new(risolte_ultimo_mese.size, risolte_ultimo_mese.each.inject(0) { |sum, el| sum = sum + el.tempo_risol_impiegato })
    @graph = open_flash_chart_object(200,100,"/todo/graph_code")
    respond_with @prodotti
  end
  
  def presa_in_carico
    @segnalazione = Segnalazione.find(params['segnalazione'][:prg_segna]);
    segnalazioni = Segnalazione.where('cda_prodotto = ?', @segnalazione.cda_prodotto).where('cda_versione_pian = ?', @segnalazione.cda_versione_pian).find_by_user_todo(current_user.user_name).order('cda_prodotto ASC') 
    @segnalazione.consegna_flg = 1;
    @in_carico = segnalazioni.in_consegna
    @in_lavorazione = @in_carico << @segnalazione
    if(@segnalazione.save!)
      SegnalazioniMailer.presa_in_carico(current_user, @segnalazione).deliver  
      # Se l'aggiornamento va a buon fine...
      flash[:notice] = "Segnalazione #{@segnalazione.prg_segna} presa in carico!."
    else 
      flash[:error] = "Errore durante il tentativo di presa in carico!."
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
    respond_to do |format|
      format.js
    end
  end
  
  def graph_code
    range_num_segna = Segnalazione.min_max_num_segna_utlimo_mese
    
    y = YAxis.new
    y.set_range(0,range_num_segna.first.num_segna, 2)
    
    x = XAxis.new
    x.set_range(1,3,1)
    
    x_legend = XLegend.new("# Segnalazioni")
    x_legend.set_style('{font-size: 14px; color: #778877}')
    
    y_legend = YLegend.new("Frequenza")
    y_legend.set_style('{font-size: 14px; color: #770077}')
    
    bar_peggiore_ns = Bar.new
    bar_peggiore_ns.colour  = '##ff1100'
    data0 = []
    data0 << range_num_segna.last.num_segna    
    #bar_peggiore_ns.key('Peggiore', 10)
    bar_peggiore_ns.set_values(data0)
    
    bar_current_user_ns = Bar.new
    bar_peggiore_ns.colour = '#7FC6FF'
    data1 = []
    data1 << 25
    #bar_current_user_ns.key('Tu', 10)
    bar_current_user_ns.set_values(data1)
    
    bar_migliore_ns = Bar.new
    bar_peggiore_ns.colour = '#ff1100'
    data2 = []
    data2 << range_num_segna.first.num_segna
    #bar_migliore_ns.key('Migliore', 10)
    bar_migliore_ns.set_values(data2)
    
    g = OpenFlashChart.new(:tool_tip => "ciao")
    g.set_title("Statistiche ultimo mese")
    g.set_x_legend(x_legend)
    g.set_y_legend(y_legend)
    g.x_axis = x
    g.y_axis = y
    
    g.add_element(bar_current_user_ns)
    g.add_element(bar_current_user_ns)
    g.add_element(bar_migliore_ns)
    
    #render :text => g.render
    render :text => g.to_s
  end
  
end
