class Statistica

	attr_accessor :num_segna, :tot_ore

	def initialize(num_segna, tot_ore)
		@num_segna = num_segna
		@tot_ore = tot_ore
	end

  def range_num_segna 
    puts "RANGEEEEEEEE!!!!!!!!!!!!!!!!!!!!!!!!!! #{[worst_num_segna_performance_last_month, best_num_segna_performance_last_month]}"
    [worst_num_segna_performance_last_month, best_num_segna_performance_last_month]
  end

  def best_num_segna_performance_last_month
    Segnalazione.min_max_num_segna_utlimo_mese.first.num_segna
  end

  def worst_num_segna_performance_last_month
    Segnalazione.min_max_num_segna_utlimo_mese.last.num_segna
  end

	def to_s
		"Numero segnalazioni: #{@num_segna}\nTotale ore: #{@tot_ore}"
	end

end
