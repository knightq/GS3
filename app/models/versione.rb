class Versione < ActiveRecord::Base
	set_table_name "FW_VERSIONI"
  belongs_to :prodotto, :foreign_key => "cda_prodotto"

  def attiva?
    oggi = Time.now
    (dtm_inizio_lavori < oggi) && (oggi <= dtm_rilascio) if dtm_inizio_lavori && dtm_rilascio  
  end

  def passata?
    dtm_rilascio < Time.now if dtm_rilascio
  end

end

