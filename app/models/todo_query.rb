class TodoQuery

	include ActiveModel::Naming
	include ActiveModel::Serialization
	include ActiveModel::AttributeMethods

	attr_accessor :stato, :in_carico

  class << self
    def model_name
      @_model_name ||= ActiveModel::Name.new(self)
    end
  end 

	def to_key
		self.keys.to_a
	end

	def initialize(stato)
		@stato = stato
	end

def keys
  @keys.dup if @keys
end

	def self.find_by_status(user_name)
		su = Segnalazione.risolutore(user_name)
		tutti_gli_stati = StatoSegnalazione.lavorabile.order('ordine')
		tutti_gli_stati.to_a.reject{|s| su.to_a.select{ |s1| s1.is_in_stato?(s.cda_stato) }.empty? }
	end

	def filtra(segnalazioni)
		filtrate = segnalazioni
		filtrate = segnalazioni.where(:cda_stato => @stato) if @stato
		filtrate = filtrate.in_consegna if @in_carico
		return filtrate
	end

end
