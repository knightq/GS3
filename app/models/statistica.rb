class Statistica

	attr_accessor :num_segna, :tot_ore

	def initialize(num_segna, tot_ore)
		@num_segna = num_segna
		@tot_ore = tot_ore
	end

	def to_s
		"Numero segnalazioni: #{@num_segna}\nTotale ore: #{@tot_ore}"
	end

end
