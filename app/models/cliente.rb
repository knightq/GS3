class Cliente < ActiveRecord::Base
	set_table_name "FW_CLIENTI"

  scope :cliente_kion, where('cliente_kion_flg = 1')

end