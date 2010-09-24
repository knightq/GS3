class VersioniController < InheritedResources::Base
  before_filter :require_user

	respond_to :html, :xml, :json, :js

  actions :index
#  actions :all

  has_scope :limit, :default => 5
  has_scope :ordine, :default => 'ASC' # Va bene per le versioni aperte
  has_scope :prodotti, :default => 'SIADI'
  has_scope :aperte
  has_scope :chiuse
  has_scope :stato, :default => 'aperte'

#  def index
#    @versioni = Versione.scoped.prodotti('SIADI')#.aperte.order('CDA_VERSIONE ASC')
#  end

end
