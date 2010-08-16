module SegnalazioniHelper
 def display_container
 end

	def display_type_section(type, brands)
		brands ||= []
  	Html.div(:class => :display_type,
    			   :id => "display_type_#{type.downcase}") do |div|
			div << Html.h2("Brands displayed as #{type}")
    	div << table_into_cells(brands.map { |b| brand_span(b)}, 4)
    end
  end

  def lastStepForMe 
    state = @segnalazione.current_state
    lastStep = 0 # Tutti possono accedere all'ultimo stato utile della GS
    if current_user
      while (lastStep == 0 and state.meta[:order] > 1)
      	puts "== STATO: #{state.name} tipo #{state.name.class} == @segnalazione.actor_associated_to(state.name) = #{@segnalazione.actor_associated_to(state.name)}, == current_user.user_name = #{current_user.user_name}"
        if @segnalazione.actor_associated_to(state.name) == current_user.user_name
          lastStep = state.meta[:order] - 2
        else
          state = @segnalazione.spec.states[@segnalazione.previous_state(state)]
        end
      end
    end
    return lastStep
  end

  def brand_span(brand)
    Html.span(brand.name, :class => :brand_span,
        :id => dom_id(brand, :span))
  end


  def bar_chart(segnalazione)
    raw_data = [['Analisi', segnalazione.tempo_ris_ana_stimato || 0, segnalazione.tempo_ris_ana_impiegato || 0],
                  ['Risoluzione', segnalazione.tempo_risol_stimato  || 0, segnalazione.tempo_risol_impiegato  || 0],
                  ['Validazione', segnalazione.tempo_val_stimato  || 0, segnalazione.tempo_val_impiegato  || 0]];
    years = ['Stima', 'Impiegato'];
                  
    @chart = GoogleVisualr::BarChart.new
    @chart.add_column('string', 'Year')
    raw_data.each do |data|
      @chart.add_column('number', data[0])      
    end
    @chart.add_rows(years.size)

    for i in 0..(years.size-1)
      @chart.set_value(i, 0, years[i])      
    end
    
    for i in 0..(raw_data.size-1)
      for j in 1..(raw_data[i].size-1)
        @chart.set_value(j-1, i+1, raw_data[i][j])
      end  
    end
    
    options = { :width => 290, :height => 100, :is3D => true, :isStacked => true, :backgroundColor => '#CFE0FF', :legend => 'top' }
    options.each_pair { | key, value |  @chart.send "#{key}=", value }

    @chart
  end
end
