require 'lib/htmldiff' 
require 'rdiscount'

class SegnalazioniMailer < ActionMailer::Base

  include HTMLDiff
  include ActionView::Helpers::TextHelper
  

  helper_method :max_width, :position, :positions, :bar_chart, :diff, :markdown
  
  default :from => "GS on Rails <asalicetti@kion.it>"
  
  def presa_in_carico(user, segnalazione)
    @segnalazione = segnalazione
    ccies = segnalazione.actors.collect do |a| 
      attore = Utente.find_by_user_id(a)
      attore.user_mail unless attore.user_name == user.user_name
    end
    @user = user
    subject = "GS-#{segnalazione.cda_tipo_segna}.#{segnalazione.prg_segna} - Modulo:#{segnalazione.cda_modulo} - Gravita:#{segnalazione.gravita_des} - Stato:#{segnalazione.stato_des} - Vers. Ris. Pian:#{segnalazione.cda_versione_pian} - E' stata presa in consegna da #{user.user_name}"
    mail(:to => user.user_mail, :cc => ccies.compact, :subject => subject)  
  end

  def cambio_descrizione(user, segnalazione, old_des)
    @segnalazione = segnalazione
    ccies = segnalazione.actors.collect do |a| 
      attore = Utente.find_by_user_id(a)
      attore.user_mail unless attore.user_name == user.user_name
    end
    @user = user
    @descrizione_nuova = RDiscount.new(@segnalazione.des_segna) 
    @descrizione_vecchia = RDiscount.new(old_des)
    subject = "GS-#{segnalazione.cda_tipo_segna}.#{segnalazione.prg_segna} [CAMBIO DESCRIZIONE]"
    mail(:to => user.user_mail, :cc => ccies.compact, :subject => subject)    
  end

  def max_width
    200
  end
  
  def pos_max_rel
    3/4
  end
  
  def pos_max
    max_width * pos_max_rel
  end
  
  def position(val, min_max_array)
    if(val and min_max_array.compact!.size == 2)
      p_min = pos_max * val / min_max_array.max
    end 
  end
  
  def positions(values)
    if(values and values.compact!.size == 2)
      p_min = pos_max * values.min / values.max
      [p_min, pos_max]
    end
  end
  
  
  def bar_chart(segnalazione)
    raw_data = [['Analisi', segnalazione.tempo_ris_ana_stimato, segnalazione.tempo_ris_ana_impiegato],
    ['Risoluzione', segnalazione.tempo_risol_stimato, segnalazione.tempo_risol_impiegato],
    ['Validazione', segnalazione.tempo_val_stimato, segnalazione.tempo_val_impiegato]];
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
    
    options = { :width => 400, :height => 240, :title => 'Company Performance', :is3D => true, :isStacked => true }
    options.each_pair { | key, value |  @chart.send "#{key}=", value }
    
    @chart
  end
  
end
