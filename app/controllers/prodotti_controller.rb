require 'active_support/builder' unless defined?(Builder)

class ProdottiController < InheritedResources::Base

	respond_to :html, :xml, :json, :js
  before_filter :require_user#, :only => [:show, :edit, :update]

  has_scope :limit, :default => 10
  has_scope :cda_prodotto_like

  # Da usarsi con dhtmlxGrid
  def data
    @prodotti = Prodotto.order(:cda_prodotto).to_a
  end

  def dbaction
      #called for all db actions
      prodotto    = params["c0"]
      descrizione = params["c1"]
      kim         = params["c2"]
      iso9000     = params["c3"]

      @mode = params["!nativeeditor_status"]
     
      @id = params["gr_id"]
      case @mode
          when "inserted"
              prodotto = Prodotto.new
              prodotto.cda_prodotto = prodotto
              prodotto.des_prodotto = descrizione
              prodotto.kim_flg = kim 
              prodotto.iso9000_flg = iso9000 
              prodotto.save!
              @tid = prodotto.cda_prodotto
          when "deleted"
            puts "GRID ID =========================== >>>> #{@id.to_i}"
              prodotto = Prodotto.find(@id.to_i)
              prodotto.destroy
              @tid = @id
          when "updated"
              prodotto = Prodotto.find(@id.to_i)
              prodotto.cda_prodotto = prodotto
              prodotto.des_prodotto = descrizione
              prodotto.kim_flg = kim 
              prodotto.iso9000_flg = iso9000 
              prodotto.save!
              @tid = @id
      end
  end
end
