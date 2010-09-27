class Prodotto < ActiveRecord::Base
	set_table_name "FW_PRODOTTI"
  set_primary_key :cda_prodotto 

	has_many :versions
  has_many :segnalazioni

  scope :cda_prodotto_like, proc { |cda_prodotto| where("cda_prodotto LIKE ?", "%#{cda_prodotto.upcase}%") }
  scope :involve_user, lambda { |user| join(:segnalazioni).where("? in (FW_SEGNA.CDA_RISOLUTORE_ANA, FW_SEGNA.CDA_RISOLUTORE, FW_SEGNA.CDA_VALIDATORE)", user) }

end
