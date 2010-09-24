class Versione < ActiveRecord::Base
	set_table_name "FW_VERSIONI"
  belongs_to :prodotto, :foreign_key => "cda_prodotto"
  has_many :segnalazioni, :foreign_key => 'cda_versione_pian', :primary_key => :cda_versione

  default_scope :include => :segnalazioni

  scope :prodotti, lambda { |prodotti| where("cda_prodotto in (?)", prodotti) }
  scope :aperte, where("dtm_rilascio >= ?", Time.zone.now)
  scope :chiuse, where("dtm_rilascio < ?", Time.zone.now)
  scope :ordine, lambda { |ord| order("cda_versione #{ord}") }
  scope :stato, lambda { |stato| where("dtm_rilascio " + (stato == 'aperte' ? ">=" : "<") + "?", Time.zone.now).ordine(stato == 'aperte' ? 'ASC' : 'DESC') }

  def attiva?
    oggi = Time.now
    (dtm_inizio_lavori < oggi) && (oggi <= dtm_rilascio) if dtm_inizio_lavori && dtm_rilascio  
  end

  def passata?
    dtm_rilascio < Time.now if dtm_rilascio
  end

end

