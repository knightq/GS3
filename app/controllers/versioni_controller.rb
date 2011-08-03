class VersioniController < InheritedResources::Base

  before_filter :require_user

	respond_to :html, :xml, :json, :js

  #actions :index
  actions :all

  has_scope :limit, :default => 5
  has_scope :ordine, :default => 'ASC' # Va bene per le versioni aperte
  has_scope :prodotti
  has_scope :aperte
  has_scope :chiuse
  has_scope :stato, :default => 'aperte', :only => :index

  def index
    params[:prodotti] ||= Segnalazione.involved_as_resolver(current_user.user_id).select('distinct fw_segna.cda_prodotto').joins(:prodotto).collect{|s| s.prodotto}[0].cda_prodotto 
    index! {}
  end

  def chiudi
    cambio_stato('C')
  end

  def depreca
    cambio_stato('D')
  end

private
  def cambio_stato(stato='A')
    @versione = Versione.find(params[:id])
    if @versione.update_attribute(:stato_versione, stato)
      redirect_to :index, :notice =>"Versione #{@versione} #{stato == 'C' ? 'CHIUSA' : 'DEPRECATA'}"
    else
      redirect_to :index, :error =>"Errore in fase di cambio stato versione"
    end
  end
end
