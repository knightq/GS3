class Funzione < EphemeralModel

	include ActiveModel::Naming
	include ActiveModel::Serialization
	include ActiveModel::AttributeMethods

	attr_accessor :fn_name

  class << self
    def model_name
      @_model_name ||= ActiveModel::Name.new(self)
    end
  end 

	def to_key
		self.keys.to_a
	end

	def keys
		@keys.dup if @keys
	end

end
