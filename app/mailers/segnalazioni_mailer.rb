class SegnalazioniMailer < ActionMailer::Base
  helper_method :max_pos, :position, :positions

  default :from => "GS on Rails <asalicetti@kion.it>"
  
  def presa_in_carico(user, segnalazione)
    @segnalazione = segnalazione
    @user = user
    subject = "GS-#{segnalazione.cda_tipo_segna}.#{segnalazione.prg_segna} - Modulo:#{segnalazione.cda_modulo} - Gravità:#{segnalazione.gravita_des} - Stato:#{segnalazione.stato_des} - Vers. Ris. Pian:#{segnalazione.cda_versione_pian} - E' stata presa in consegna da #{user.user_name}"
    mail(:to => user.user_mail, :subject => subject)  
  end

  def max_width
    200
  end

  def pos_max_rel
    3/4
  end

  def pos_max
    max_width * pos_max_rel
  end

  def position(val, min_max_array)
    if(val and min_max_array.compact!.size == 2)
      p_min = pos_max * val / min_max_array.max
    end 
  end

  def positions(values)
    if(values and values.compact!.size == 2)
      p_min = pos_max * values.min / values.max
      [p_min pos_max]
    end 
  end

end
