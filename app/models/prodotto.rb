class Prodotto < ActiveRecord::Base
	set_table_name "FW_PRODOTTI"
	has_many :versions

end
