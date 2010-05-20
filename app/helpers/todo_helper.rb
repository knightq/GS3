module TodoHelper
	def versione_class(cda_versione)
		versione = Versione.find_by_cda_versione(cda_versione)
		if versione
			oggi = Time.now
			if((versione.dtm_inizio_lavori < oggi) && (oggi < versione.dtm_rilascio)) 
				classe = 'corrente'
			elsif (versione.dtm_rilascio < oggi)
				classe = 'chiusa'
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

end
