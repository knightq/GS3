class StatisticheController < ApplicationController

	attr_accessor :statistica

	def index
    @graph = open_flash_chart_object(300,200,"/statistiche/graph_code")
    @graph_ore = open_flash_chart_object(450,200,"/statistiche/graph_code_ore")
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

		chart = OpenFlashChart.new (:tool_tip => "ciao")
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
		chart.x_axis = x
    chart.y_axis = y

    line = Line.new
    line.text = "Numero segnalazioni risolte"
    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data1
		line.tooltip = "#val# sviluppatori hanno risolto #key# segnalazioni in ultimo mese"

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
		ore_impiegate = statistica.order("ore_impiegate ASC").collect{|s| s.ore_impiegate}.to_a
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
#    labels.steps = 86400
#   labels.visible_steps = 2
    labels.set_vertical
    x.labels = labels

#    x.set_range(1, lista_sviluppatori.size)
#		x.set_labels(lista_sviluppatori)


    y_legend = YLegend.new("Ore impiegate")
    y_legend.set_style('{font-size: 14px; color: #770077}')

		chart = OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y
		chart.x_axis = x

	  bar = BarGlass.new
    bar.set_values(ore_impiegate)
    chart.add_element(bar)
    render :text => chart.to_s
  end


	def graph_code_demo
    title = Title.new("Multiple Lines")

    data1 = []
    data2 = []
    data3 = []

    10.times do |x|
      data1 << rand(5) + 1
      data2 << rand(6) + 7
      data3 << rand(5) + 14
    end

    line_dot = LineDot.new
    line_dot.text = "Line Dot"
    line_dot.width = 4
    line_dot.colour = '#DFC329'
    line_dot.dot_size = 5
    line_dot.values = data1

    line_hollow = LineHollow.new
    line_hollow.text = "Line Hollow"
    line_hollow.width = 1
    line_hollow.colour = '#6363AC'
    line_hollow.dot_size = 5
    line_hollow.values = data2

    line = Line.new
    line.text = "Line"
    line.width = 1
    line.colour = '#5E4725'
    line.dot_size = 5
    line.values = data3

    y = YAxis.new
    y.set_range(0,20,5)

    x_legend = XLegend.new("MY X Legend")
    x_legend.set_style('{font-size: 20px; color: #778877}')

    y_legend = YLegend.new("MY Y Legend")
    y_legend.set_style('{font-size: 20px; color: #770077}')

    chart =OpenFlashChart.new
    chart.set_title(title)
    chart.set_x_legend(x_legend)
    chart.set_y_legend(y_legend)
    chart.y_axis = y

    chart.add_element(line_dot)
    chart.add_element(line_hollow)
    chart.add_element(line)

    render :text => chart.to_s
  end

private
	def calcola_statistiche
		@statistica = Segnalazione.ultimo_mese.risolte.select("cda_risolutore, count(*) as num_segna, sum(tempo_risol_impiegato) as ore_impiegate").group(:cda_risolutore)
	end

end
