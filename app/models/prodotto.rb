class Prodotto < ActiveRecord::Base
	set_table_name "FW_PRODOTTI"
  set_primary_key :cda_prodotto 

	has_many :versions

  scope :cda_prodotto_like, proc { |cda_prodotto| where("cda_prodotto LIKE ?", "%#{cda_prodotto.upcase}%") }


end
