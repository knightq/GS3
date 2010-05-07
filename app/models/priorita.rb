class Priorita < ActiveRecord::Base
	set_table_name "FW_PRIORITA"

	def self.range
		Priorita.all.collect(&:des_priorita).reverse
	end

end
