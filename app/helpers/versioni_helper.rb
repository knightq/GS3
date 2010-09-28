module VersioniHelper

  def filtra_segnalazioni(versione)
    segnalazioni = versione.segnalazioni || []
    unless params[:all]
      segnalazioni = segnalazioni.select {|s| s.involved_as_resolver(current_user)} unless params[:all]
    end
    segnalazioni.sort{|x, y| (x.cda_tipo_segna <=> y.cda_tipo_segna)*100000 + x.prg_segna <=> y.prg_segna}
  end
  
  def prodotti
    @prodotti = @prodotti || Segnalazione.involved_as_resolver(current_user.user_id).select('distinct fw_segna.cda_prodotto').joins(:prodotto).collect{|s| s.prodotto}  
  end

end