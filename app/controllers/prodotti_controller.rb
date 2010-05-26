class ProdottiController < ApplicationController

	respond_to :html, :xml, :json, :js

  # GET /prodotti
  # GET /prodotti.xml
  def index
    @prodotti = Prodotto.scoped
    @prodotti = @prodotti.where("cda_prodotto LIKE ?", "%#{params[:q].upcase}%") if params[:q] 
    @prodotti = @prodotti.order('cda_prodotto ASC').limit(10)
    respond_with(@prodotti)
  end

end
