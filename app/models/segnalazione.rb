class Segnalazione < ActiveRecord::Base
	set_table_name "FW_SEGNA"

	belongs_to :risolutore, :foreign_key => 'cda_risolutore', :class_name => 'Utente'
	belongs_to :risolutore_analisi, :foreign_key => 'cda_risolutore_ana', :class_name => 'Utente'

	scope :ultimo_mese, where("dtm_risoluzione between ? and ?", Time.zone.now - 30.days, Time.zone.now)
	scope :assegnate, where('cda_stato in (?)', ['AS', 'AA'])
	scope :in_consegna, where('consegna_flg = 1')
	scope :risolte, where('cda_stato in (?)', ['RI', 'VL'])
	scope :risolutore, lambda { |user| where("cda_risolutore = ?", user) }

	def self.find_by_user_todo(user_id)
		segnalazione = Segnalazione.risolutore(user_id).assegnate
	end

	def self.count_by_user_and_stato(user_id, stato)
		Segnalazione.risolutore(user_id).where(:cda_stato => stato).count
	end

	def self.risolte_ultimo_mese(user_id)
		risolte_ultimo_mese = Segnalazione.risolutore(user_id).risolte.ultimo_mese
	end

	def self.min_max_num_segna_utlimo_mese()
		Segnalazione.ultimo_mese.risolte.select("count(*) as num_segna").group(:cda_risolutore).order("num_segna DESC")
	end

	def stato_des
		StatiSegnalazione.des(cda_stato)
	end

	def is_in_stato?(stato)
		cda_stato == stato
	end

	def aa?
		is_in_stato? 'AA'
  end

	def as?
		is_in_stato? 'AS'
  end

end

