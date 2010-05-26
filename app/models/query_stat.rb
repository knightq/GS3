class QueryStat < ActiveForm

	attr_accessor :time_span_da, :time_span_a

	validate :valid_date?

  def valid_date?
    unless time_span_da < time_span_a
      errors.add(:time_span_da, "deve essere antecedente a #{time_span_a}")
    end
  end

end
