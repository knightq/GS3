class ProdottiController < ApplicationController

	respond_to :html, :xml, :json

  # GET /prodotti
  # GET /prodotti.xml
  def index
    @prodotti = Prodotto.all
    respond_with(@prodotti)
  end

end
