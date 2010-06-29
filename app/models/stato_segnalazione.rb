class StatoSegnalazione < ActiveRecord::Base

  set_table_name "FW_STAT_SEGN"

#  has_many :utenti
	scope :lavorabile, where("lavorabile_analisi_flg = 1 OR lavorabile_sviluppo_flg = 1 OR lavorabile_test_flg = 1")
	scope :aperta, where(:aperta_flg => 1)

	def self.aperta?(cda_stato)
		StatoSegnalazione.aperta.where(:cda_stato => cda_stato).count > 0
	end

	def self.des(cda_stato)
		@@stati ||= Hash.new
		StatoSegnalazione.all.each { |stato| @@stati.store(stato.cda_stato, stato.des_stato)} if @@stati.empty?
		@@stati[cda_stato]
  end

  def <=>(statoSegnalazione) # Comparatore
    cda_stato <=> statoSegnalazione.cda_stato
  end

  def ==(statoSegnalazione) # Comparison operator for sorting
    ordine == statoSegnalazione.ordine
  end

  def <(statoSegnalazione) # Comparison operator for sorting
    ordine < statoSegnalazione.ordine
  end

  def <=(statoSegnalazione) # Comparison operator for sorting
    ordine <= statoSegnalazione.ordine
  end

  def >(statoSegnalazione) # Comparison operator for sorting
    ordine > statoSegnalazione.ordine
  end

  def >=(statoSegnalazione) # Comparison operator for sorting
    ordine >= statoSegnalazione.ordine
  end
  
end
