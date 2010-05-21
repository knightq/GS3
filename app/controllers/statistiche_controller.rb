class StatisticheController < ApplicationController

	before_filter :require_user

	attr_accessor :statistica

	def index
    @graph = open_flash_chart_object(600,400,"/statistiche/graph_code")
    @graph_ore = open_flash_chart_object(600,400,"/statistiche/graph_code_ore")
	end

  def graph_code
		calcola_statistiche
		num_segna = statistica.order("num_segna ASC").collect{|s| s.num_segna}.uniq.to_a
		freq = num_segna.collect {|ns| num_svil_for_num_segna(ns)}
    title = Title.new("# segnalazioni risolte ultimo mese da sviluppatori")
		data1 = []
		range_num_segna = (0..num_segna.max)
		range_freq = (0..freq.max)
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
		user_val = statistica.where("CDA_RISOLUTORE = '#{@current_user.user_name}'")[0].num_segna
		serie_svil = Array.new(data1.size) { |i| i == user_val ? data1[i] : nil }
		bar1.set_values(serie_svil)
    bar1.colour  = '#0000FF'
		bar1.tooltip = "#{@current_user.user_name} ha risolto #x_label# GS nell'ultimo mese"
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
		statistica.having("count(*) = #{num_segna}").to_a.count
	end

  def graph_code_ore
		calcola_statistiche
		ore_impiegate = statistica.order("ore_impiegate ASC").collect{|s| s.ore_impiegate}
		title = Title.new("Ore impiegate nell'ultimo mese dagli sviluppatori")

		range_ore_impiegate = (0..ore_impiegate.size)

   	y = YAxis.new
    y.set_range(0,ore_impiegate.max.ceil,1)

    x_legend = XLegend.new("Sviluppatori")
    x_legend.set_style('{font-size: 14px; color: #778877}')

		lista_sviluppatori = statistica.order("ore_impiegate ASC").collect{|s| s.cda_risolutore}.to_a

   	x = XAxis.new

		labels = XAxisLabels.new
    labels.text = "#val#"# lista_sviluppatori[val]
    labels.set_vertical
    x.labels = labels

		x.set_labels(lista_sviluppatori)
#		x.labels.set_vertical


    y_legend = YLegend.new("Ore impiegate")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new
#		chart.bg_colour = '#000000'
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
		chart.x_axis = x

		ore_impiegate_svil = statistica.order("ore_impiegate ASC").where("CDA_RISOLUTORE = '#{@current_user.user_name}'")[0].ore_impiegate
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
		user_val = statistica.where("CDA_RISOLUTORE = '#{@current_user.user_name}'")[0].ore_impiegate
		serie_svil = Array.new(ore_impiegate.size) { |i| ore_impiegate[i] == user_val ? user_val : nil }
		bar1.set_values(serie_svil)
    bar1.colour  = '#0000FF'
		bar1.tooltip = "#{@current_user.user_name} ha impiegato #val# ore nel risolvere le GS nell'ultimo mese"
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

private
	def calcola_statistiche
		@statistica = Segnalazione.ultimo_mese.risolte.select("cda_risolutore, count(*) as num_segna, sum(tempo_risol_impiegato) as ore_impiegate").group(:cda_risolutore)
	end

end
