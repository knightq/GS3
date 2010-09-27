class VersioniController < InheritedResources::Base
  before_filter :require_user

	respond_to :html, :xml, :json, :js

  actions :index
#  actions :all

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

end
