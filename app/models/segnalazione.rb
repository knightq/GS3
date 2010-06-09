class Segnalazione < ActiveRecord::Base
	set_table_name "FW_SEGNA"

	belongs_to :gravita, :foreign_key => 'cdn_gravita', :class_name => 'Gravita'
  belongs_to :risolutore, :foreign_key => 'cda_risolutore', :class_name => 'Utente'
  belongs_to :risolutore_analisi, :foreign_key => 'cda_risolutore_ana', :class_name => 'Utente'
  belongs_to :prodotto, :foreign_key => 'cda_prodotto', :class_name => 'Prodotto'

  validates_presence_of :prodotto

	scope :time_span, lambda { |da, time_span_behind| where("dtm_risoluzione between ? and ?", da - time_span_behind, da) }
	scope :time_span_by_today, lambda { |time_span_behind| time_span(Time.zone.now, time_span_behind) }
	scope :ultimo_mese, time_span(Time.zone.now, 1.month)
	scope :assegnate, where('cda_stato in (?)', ['AS', 'AA'])
	scope :in_consegna, where('consegna_flg = 1')
	scope :risolte, where('cda_stato in (?)', ['RS', 'VL'])
	scope :risolutore, lambda { |user| where("cda_risolutore = ?", user) }
	scope :risolutori, lambda { |users| where("cda_risolutore in (?)", users) }

	def self.find_by_user_todo(user_id)
		Segnalazione.risolutore(user_id).assegnate
	end

	def self.count_by_user_and_stato(user_id, stato)
		Segnalazione.risolutore(user_id).where(:cda_stato => stato).count
	end

	def self.risolte_ultimo_mese(user_id)
		Segnalazione.risolutore(user_id).risolte.ultimo_mese
	end

	def self.min_max_num_segna_utlimo_mese()
		Segnalazione.ultimo_mese.risolte.select("count(*) as num_segna").group(:cda_risolutore).order("num_segna DESC")
	end

	def self.performance_score_by_user_over_time(user_name, time_span = nil)
		rel = Segnalazione.risolutori(user_name).select("cda_risolutore, sum(NVL(tempo_risol_stimato,1))/sum(NVL(tempo_risol_impiegato,1)) as performance").group(:cda_risolutore).having("sum(nvl(tempo_risol_impiegato,1)) > 0")
		rel = rel.time_span_by_today(time_span) if time_span
		rel.order("performance ASC")
	end

	def self.num_segna_by_user_over_time(user_name)
		Segnalazione.risolutori(user_name).risolte.select("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy') as mese, count(*) AS num_segna").group("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").order("mese ASC")
	end

	def self.performance_score_by_user_by_time(user_name)
		Segnalazione.risolutori(user_name).select("cda_risolutore, sum(NVL(tempo_risol_stimato,1))/sum(NVL(tempo_risol_impiegato,1)) as performance, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").group("cda_risolutore, TO_CHAR(dtm_risoluzione,'yyyy mm MON-yy')").having("sum(nvl(tempo_risol_impiegato,1)) > 0")
	end

	def stato_des
		StatiSegnalazione.des(cda_stato)
	end

	def is_in_stato?(stato)
		cda_stato == stato
	end

	def performance_score
		ore_stima = :tempo_risol_stimato ? :tempo_risol_stimato : 1
		ore_impiegate = :tempo_risol_impiegato ? :tempo_risol_impiegato : 1;
		ore_stima / ore_impiegate
	end

  def aa?
    is_in_stato? 'AA'
  end

  def as?
    is_in_stato? 'AS'
  end

  def ve?
    is_in_stato? 'VE'
  end

  # Virtual Attributres
  def cod_prodotto
    prodotto.cda_prodotto if prodotto
  end

  def cod_prodotto=(cda_prodotto)
    puts "SET cod_prodotto!!!! #{cda_prodotto}"
    self.prodotto = Prodotto.find_by_cda_prodotto(cda_prodotto) unless cda_prodotto.blank?
  end
end

