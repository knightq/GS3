class StatisticheController < ApplicationController

	before_filter :require_user

	respond_to :html, :xml, :json, :js

	def index
    @tempo_totale_risol_stimato_quest_anno = Segnalazione.risolutore(@current_user.user_id).time_span_by_today(1.year).sum(:tempo_risol_stimato).round(2)
    @tempo_totale_risol_stimato_anno_precedente = Segnalazione.risolutore(@current_user.user_id).time_span(Time.zone.now-1.year, 1.year).sum(:tempo_risol_stimato).round(2)
    @tempo_totale_risol_impiegato_quest_anno = Segnalazione.risolutore(@current_user.user_id).time_span_by_today(1.year).sum(:tempo_risol_impiegato).round(2)
    @tempo_totale_risol_impiegato_anno_precedente = Segnalazione.risolutore(@current_user.user_id).time_span(Time.zone.now-1.year, 1.year).sum(:tempo_risol_impiegato).round(2)

    if @tempo_totale_risol_impiegato_quest_anno
      @performance_quest_anno = (100 * @tempo_totale_risol_stimato_quest_anno / @tempo_totale_risol_impiegato_quest_anno).round(2)
    else
      @performance_quest_anno = 0
    end

    if @tempo_totale_risol_stimato_anno_precedente
      @diff_stima = (100 * @tempo_totale_risol_stimato_quest_anno / @tempo_totale_risol_stimato_anno_precedente - 100).round(2)
    else 
      @diff_stima = 0
    end

    if @tempo_totale_risol_impiegato_anno_precedente
      @diff_impiegato = (100 * @tempo_totale_risol_impiegato_quest_anno / @tempo_totale_risol_impiegato_anno_precedente - 100).round(2)
      @performance_anno_precedente = (100 * @tempo_totale_risol_stimato_anno_precedente / @tempo_totale_risol_impiegato_anno_precedente).round(2)
      @diff_performance = (100 * @performance_quest_anno / @performance_anno_precedente - 100).round(2)
    else
      @diff_impiegato = 0
      @performance_anno_precedente = 0
      @diff_performance = @performance_quest_anno
    end

    unless @statistica_filter
      puts "Creo un nuovo filtro... "  
      @statistica_filter = QueryStat.new
      @statistica_filter.time_span_da = Date.today - 1.month
      @statistica_filter.time_span_a = Date.today
    end
    if params[:query_stat]
        @statistica_filter.time_span_da = params[:query_stat][:time_span_da]
        @statistica_filter.time_span_a = params[:query_stat][:time_span_a]
    end
    @graph = open_flash_chart_object(600,400,"/statistiche/graph_code")
    @graph_ore = open_flash_chart_object(600,400,"/statistiche/graph_code_ore")
		@graph_performance = open_flash_chart_object(600,400,"/statistiche/graph_code_performance")
		@timeline = open_flash_chart_object(600,400,"/statistiche/timeline_code")
	end

  def graph_code
    unless @statistica_filter
      puts "Creo un nuovo filtro... "  
      @statistica_filter = QueryStat.new
      @statistica_filter.time_span_da = Date.today - 1.month
      @statistica_filter.time_span_a = Date.today
    end
    if params[:query_stat]
        @statistica_filter.time_span_da = params[:query_stat][:time_span_da]
        @statistica_filter.time_span_a = params[:query_stat][:time_span_a]
    end
    @statistica = calcola_statistiche(@statistica_filter)
		num_segna = @statistica.order("num_segna ASC").collect{|s| s.num_segna}.uniq.to_a
    puts "NUMERO SEGNALAZIONI: #{num_segna}"
		freq = num_segna.collect {|ns| num_svil_for_num_segna(ns)}
    puts "FREQUENZA: #{freq}"
    title = Title.new("# segnalazioni risolte ultimo mese da sviluppatori")
		data1 = []
    puts "NUM_SEGNA MAX: #{num_segna.max}"
		range_num_segna = (0..num_segna.max)
		i = 0
		range_num_segna.each do |f|
			if num_segna.include?(f) then
				data1 << freq[i]
				i = i + 1
	    else
				data1 << 0
	    end
		end

   	y = YAxis.new
    y.set_range(0,freq.max,1)

   	x = XAxis.new
    x.set_range(range_num_segna.min,range_num_segna.max,1)

    x_legend = XLegend.new("# Segnalazioni")
    x_legend.set_style('{font-size: 14px; color: #778877}')

    y_legend = YLegend.new("Frequenza")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new(:tool_tip => "ciao")
#		chart.bg_colour = '#000000'
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
		chart.x_axis = x
    chart.y_axis = y


	  bar = Bar.new
    bar.set_values(data1)
  	bar.colour  = '#11AAFF'
		bar.tooltip = "#val# sviluppatori hanno risolto #x# segnalazioni in questo ultimo mese"
    chart.add_element(bar)

	  bar1 = Bar.new
		user_val = @statistica.where("CDA_RISOLUTORE = '#{@current_user.user_id}'")[0].num_segna
		serie_svil = Array.new(data1.size) { |indx| indx == user_val ? data1[indx] : nil }
		bar1.set_values(serie_svil)
    bar1.colour  = '#0000FF'
		bar1.tooltip = "#{@current_user.user_id} ha risolto #x_labels(1)# GS nell'ultimo mese"
    chart.add_element(bar1)

    line = Line.new
    line.text = "Media"
    line.width = 3
    line.colour = '#FF0000'
    line.dot_size = 5
		serie_media = Array.new(data1.size)
		if not serie_media.empty? 
			serie_media.pop
			serie_media.push(data1.media)
			serie_media[0] = data1.media
		end
    line.values = serie_media
		line.tooltip = "Media"
		chart.add_element(line)
	  render :text => chart.to_s
  end

	def ttip(ns)
		nsfns = num_svil_for_num_segna(ns)
		"Ci sono #{nsfns} sviluppatori che hanno risolto  segnalazioni"
	end

	def num_svil_for_num_segna(num_segna)
		@statistica.having("count(*) = #{num_segna}").to_a.count
	end

  def graph_code_ore
    unless @statistica_filter
      puts "Creo un nuovo filtro... "  
      @statistica_filter = QueryStat.new
      @statistica_filter.time_span_da = Date.today - 1.month
      @statistica_filter.time_span_a = Date.today
    end
    if params[:query_stat]
        @statistica_filter.time_span_da = params[:query_stat][:time_span_da]
        @statistica_filter.time_span_a = params[:query_stat][:time_span_a]
    end
		@statistica = calcola_statistiche(@statistica_filter)
		ore_impiegate = @statistica.order("ore_impiegate ASC").collect{|s| s.ore_impiegate}
		title = Title.new("Ore impiegate nell'ultimo mese dagli sviluppatori")

   	y = YAxis.new
    y.set_range(0,ore_impiegate.max.ceil,1)

    x_legend = XLegend.new("Sviluppatori")
    x_legend.set_style('{font-size: 14px; color: #778877}')

		lista_sviluppatori = @statistica.order("ore_impiegate ASC").collect{|s| s.cda_risolutore}.to_a

   	x = XAxis.new

		labels = XAxisLabels.new
    labels.text = "#val#"# lista_sviluppatori[val]
    labels.set_vertical
    x.labels = labels

		x.set_labels(lista_sviluppatori)


    y_legend = YLegend.new("Ore impiegate")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new
#		chart.bg_colour = '#000000'
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
		chart.x_axis = x

		ore_impiegate_svil = @statistica.order("ore_impiegate ASC").where("CDA_RISOLUTORE = '#{@current_user.user_id}'")[0].ore_impiegate
	  bar = BarGlass.new
		bar.colour  = '#11AAFF'
		already_removed = false
		oi_without_me = ore_impiegate.collect do |oi|
			if(oi == ore_impiegate_svil and not already_removed)
				already_removed = true
				nil
			else
				oi
			end
		end
    bar.set_values(oi_without_me)
		bar.tooltip = 'Tizio #key# #x_label# ha sviluppato per #val# ore nell''ultimo mese'
    chart.add_element(bar)

	  bar1 = BarGlass.new
		bar1.pad_x = 0
		bar1.pad_y = 0
		user_val = @statistica.where("CDA_RISOLUTORE = '#{@current_user.user_id}'")[0].ore_impiegate
		serie_svil = Array.new(ore_impiegate.size) { |i| ore_impiegate[i] == user_val ? user_val : nil }
		bar1.set_values(serie_svil)
    bar1.colour  = '#0000FF'
		bar1.tooltip = "#{@current_user.user_id} ha impiegato #val# ore nel risolvere le GS nell'ultimo mese"
    chart.add_element(bar1)

    line = Line.new
	  line.text = "Media"
    line.width = 3
    line.colour = '#FF0000'
    line.dot_size = 5
		serie_media = Array.new(ore_impiegate.size)
		if not serie_media.empty? 
			serie_media.pop
			serie_media.push(ore_impiegate.media)
			serie_media[0] = ore_impiegate.media
		end
    line.values = serie_media
		line.tip = 'Media #val#'
		chart.add_element(line)

    render :text => chart.to_s
  end

	def graph_code_performance
		performances = Segnalazione.performance_score_by_user_over_time(Utente.where("user_id != 'ADMIN'").to_a.collect{|x| x.user_id})
		title = Title.new("Performance (sum(tempo_stimato) / sum(tempo_impiegato)) nell'ultimo mese dagli sviluppatori")

		range_performance = (0..performances.last.performance.ceil)

   	y = YAxis.new
    y.set_range(0,range_performance.max,1)

    x_legend = XLegend.new("Sviluppatori")
    x_legend.set_style('{font-size: 14px; color: #778877}')

		lista_sviluppatori = performances.collect{|s| s.cda_risolutore}.to_a

   	x = XAxis.new

		labels = XAxisLabels.new
    labels.text = "#val#"# lista_sviluppatori[val]
    labels.set_vertical
    x.labels = labels

		x.set_labels(lista_sviluppatori)

    y_legend = YLegend.new("Ore impiegate")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
		chart.x_axis = x

	  bar = BarGlass.new
		bar.colour  = '#11AAFF'
    bar.set_values(performances.collect{|p| p.performance})
		bar.tooltip = 'Performance: #val#'
    chart.add_element(bar)

    line = Line.new
	  line.text = "Media"
    line.width = 3
    line.colour = '#FF0000'
    line.dot_size = 5
		serie_media = Array.new(performances.size)
		if not serie_media.empty? 
			p_media = performances.collect{|p| p.performance}.media
			serie_media.pop
			serie_media.push(p_media)
			serie_media[0] = p_media
		end
    line.values = serie_media
		line.tip = 'Media #val#'
		chart.add_element(line)

    render :text => chart.to_s
	end

	def timeline_code
		resultset = Segnalazione.num_segna_by_user_over_time(@current_user.user_id)
		gs_risolte_per_mese = resultset.collect{|s| s.num_segna}.last(12)
		gs_risolte_per_mese_prev = resultset.collect{|s| s.num_segna}[-23..-12]
		performances = Segnalazione.performance_score_by_user_by_time(@current_user.user_id)
		performance_per_mese = performances.last(12).collect{|p| p.performance * 10}
		performance_per_mese_prev = performances[-23..-12].collect{|p| p.performance * 10}
		gs_risolte_per_mese = resultset.collect{|s| s.num_segna}.last(12)

		mesi = resultset.collect{|s| s.mese}.compact.last(12).collect{|s| s[-6..-4]}
		title = Title.new("Timeline per #{@current_user.user_id}")

		y = YAxis.new
    y.set_range(0, gs_risolte_per_mese.max, 2)

    x_legend = XLegend.new("Mese")
    x_legend.set_style('{font-size: 10px; color: #778877}')

   	x = XAxis.new
		labels = XAxisLabels.new
    labels.text = "#val#"# lista_sviluppatori[val]
    labels.set_vertical
    x.labels = labels

		x.set_labels(mesi)

    y_legend = YLegend.new("GS risolte")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
		chart.x_axis = x

    line = Line.new
	  line.text = "GS risolte ultimi 12 mesi"
    line.width = 4
    line.colour = '#FF0000'
    line.dot_size = 5
    line.values = gs_risolte_per_mese
		chart.add_element(line)

    line_prev = Line.new
	  line_prev.text = "GS risolte nello stesso periodo, anno precedente"
    line_prev.width = 2
    line_prev.colour = '#FFA700'
    line_prev.dot_size = 3
    line_prev.values = gs_risolte_per_mese_prev
		chart.add_element(line_prev)

    line_perf = Line.new
	  line_perf.text = "Performance (x10) ultimi 12 mesi"
    line_perf.width = 4
    line_perf.colour = '#0000FF'
    line_perf.dot_size = 5
    line_perf.values = performance_per_mese
		chart.add_element(line_perf)

    line_perf_prev = Line.new
	  line_perf_prev.text = "Performance (x10) nello stesso periodo, anno precedente"
    line_perf_prev.width = 2
    line_perf_prev.colour = '#0071AF'
    line_perf_prev.dot_size = 3
    line_perf_prev.values = performance_per_mese_prev
		chart.add_element(line_perf_prev)

    render :text => chart.to_s
	end

private
	def calcola_statistiche(sf)
    if sf
      puts "CALCOLO STATISTICHE da #{sf.time_span_da} a #{sf.time_span_a}..."
		  @statistica = Segnalazione.time_span(sf.time_span_a, (sf.time_span_a - sf.time_span_da)).risolte.select("cda_risolutore, count(*) as num_segna, sum(tempo_risol_impiegato) as ore_impiegate").group(:cda_risolutore)
		end
    return @statistica
	end

end
