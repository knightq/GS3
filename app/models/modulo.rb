class Modulo < ActiveRecord::Base
	set_table_name "FW_MODULI"

  scope :kim, where('kim_flg = 1')

end
