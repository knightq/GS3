class Gravita < ActiveRecord::Base
	set_table_name "FW_GRAVITA"

	def self.range
		Gravita.all.collect(&:des_gravita).reverse
	end

end
