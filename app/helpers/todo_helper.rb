module TodoHelper
	def versione_class(versione_coll)
		if versione_coll
      versione = Versione.find_by_cda_versione(versione_coll)
      if versione
        if versione.attiva? 
          classe = 'corrente'
        elsif (versione.passata?)
          classe = 'chiusa'
        end
      end      
    end
		classe ||= ''
	end

	def filter_by_status
		TodoQuery.find_by_status(current_user.user_name)
	end

	def count_by_stato(stato)
		@segnalazioni.to_a.select{ |s| s.is_in_stato?(stato) }.count
	end

	def segnalazione_partial
		@current_user_session.compact_mode ? "segnalazione_compact" : "segnalazione"
	end

  def desc_ore(versione, prop, ck)
    ore = versione[1].inject(0) {|sum, el| sum + ((el.send(prop) if el.send(ck)) || 0)}
    giorni = ore.to_i / 8
    fraz_ore = (ore % 8).to_i
    res = "#{pluralize(giorni,"giorno")}" if giorni > 0
    res = "#{res} e " if (giorni > 0) and fraz_ore > 0
    res = "#{res} #{pluralize(fraz_ore, "ora")}" if fraz_ore > 0
    res ||= "--"
  end

  def ore_per_sezione(sezioni)
    return sezioni.inject(0){|sum, sez| sum + sez.select{|el| el.instance_of? Array}[0].inject(0) {|sum, el| sum + (el.tempo_stimato ? el.tempo_stimato : 0)}}
  end

  def grouped(segnalazioni)
    segnalazioni.group_by { |segn| segn.lavorabilita(current_user.user_name) }.sort
  end

  def wip(segnalazioni)
    segnalazioni
  end

  def ready(segnalazioni)
    segnalazioni
  end
  
  def wait(segnalazioni)
    segnalazioni
  end

end
