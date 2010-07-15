class Array
  def somma
    inject(0.0) { |result, el| result + el }
  end

  def media 
    somma / size
  end
end

module Workflow::ActiveRecordInstanceMethods
  def already?(state_as_sym)
    current_state.meta[:order] > spec.states.select{|s| s[0].to_s==state_as_sym.to_s}[0][1].meta[:order] 
  end
end