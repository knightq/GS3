class Versione < ActiveRecord::Base
	set_table_name "FW_VERSIONI"
  belongs_to :prodotto, :foreign_key => "cda_prodotto"
end

