class Gravita < ActiveRecord::Base
	set_table_name "FW_GRAVITA"

	def self.range
		Gravita.all.collect(&:des_gravita).reverse
	end

  def self.des(cdn_gravita)
    @@gravita ||= Hash.new
    Gravita.all.each { |gravita| @@gravita.store(gravita.cdn_gravita, gravita.des_gravita)} if @@gravita.empty?
    @@gravita[cdn_gravita]
  end

end
