module VersioniHelper
  def filtra_segnalazioni(versione)
    segnalazioni = versione.segnalazioni || []
    segnalazioni = segnalazioni.select {|s| s.involved_as_resolver(current_user)} if (params[:user] || params[:user] == nil)
    segnalazioni.sort{|x, y| (x.cda_tipo_segna <=> y.cda_tipo_segna)*100000 + x.prg_segna <=> y.prg_segna}
  end
end