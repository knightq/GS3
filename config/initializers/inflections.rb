# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /^([\w]*)a/i, '\1e'
  inflect.singular /^([\w]*)e/i, '\1a'
  inflect.plural /^([\w]*)o/i, '\1i'
  inflect.singular /^([\w]*)i/i, '\1o'
  inflect.irregular 'funzione', 'funzioni'
  inflect.irregular 'giorno', 'giorni'
  inflect.irregular 'gravita', 'gravita'
  inflect.irregular 'menu', 'menu'
  inflect.irregular 'ora', 'ore'
  inflect.irregular 'priorita', 'priorita'
  inflect.irregular 'prodotto', 'prodotti'
  inflect.irregular 'recapito', 'recapiti'
  inflect.irregular 'risolutore', 'risolutori'
  inflect.irregular 'segnalazione', 'segnalazioni'
  inflect.irregular 'sessione_utente', 'sessioni_utente'
  inflect.irregular 'todo', 'todo'
  inflect.irregular 'user_session', 'user_sessions'
  inflect.irregular 'utente', 'utenti'
  inflect.irregular 'versione', 'versioni'
end

module ActiveSupport::Inflector
  # does the opposite of humanize ... mostly.
  # Basically does a space-substituting .underscore
  def dehumanize(the_string)
    result = the_string.to_s.dup
    result.downcase.gsub(/ +/,'_')
  end
end

class String
  def dehumanize
    ActiveSupport::Inflector.dehumanize(self)
  end
end
