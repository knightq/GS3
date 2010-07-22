class Causa < ActiveRecord::Base
	set_table_name "FW_CAUSE"
  set_primary_key :cod_causa

  def self.des(cda_causa)
    @@cause ||= Hash.new
    Causa.all.each { |causa| @@cause.store(causa.cod_causa, causa.des)} if @@cause.empty?
    @@cause[cda_causa]
  end

end
