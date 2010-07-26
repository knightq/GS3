class Prodotto < ActiveRecord::Base
	set_table_name "FW_PRODOTTI"
  set_primary_key :cda_prodotto 

	has_many :versions

end
