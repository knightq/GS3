class Priorita < ActiveRecord::Base
	set_table_name "FW_PRIORITA"

	def self.range
		Priorita.all.collect(&:des_priorita).reverse
	end

  def self.des(cdn_priorita)
    @@priorita ||= Hash.new
    Priorita.all.each { |priorita| @@priorita.store(priorita.cdn_priorita, priorita.des_priorita)} if @@priorita.empty?
    @@priorita[cdn_priorita]
  end

end
