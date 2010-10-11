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
    current_state.meta[:order] >= spec.states[state_as_sym].meta[:order]
  end
  
  def has_to_be?(state_as_sym)
    current_state.meta[:order] < spec.states[state_as_sym].meta[:order]
  end
  
  def overcame?(state_as_sym)
    current_state.meta[:order] > spec.states[state_as_sym].meta[:order]
  end
  
end

class ActiveRecord::Base
  def utente(user_id)
    utente = Utente.user_id(user_id).includes(:recapito).to_a[0]
    if utente and utente.recapito
      "<span id=\"#{user_id}\" class=\"utente\" mail=\"#{utente.user_mail}\" phone=\"#{utente.recapito.cda_telefono}\" onmouseover=\"setupMenu(this);\" >#{user_id}</span>".html_safe
    else
      user_id
    end
  end
end