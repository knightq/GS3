require 'active_support/builder' unless defined?(Builder)

class RecapitiController < InheritedResources::Base

	respond_to :html, :xml, :json, :js

  actions :all

  has_scope :limit, :default => 5
  has_scope :cda_cognome_LIKE
  has_scope :cda_telefono_LIKE

  #before_filter :require_user, :except => [:data, :index]

  #protect_from_forgery :except => [:rubrica_data_grid]
 
#      cognome = request.GET[:cognome]
#      tel = request.GET[:tel]
#      @recapiti = Recapito.all
#      @recapiti = @recapiti.where("cda_cognome like '%#{cognome}%' ") if (cognome and not cognome.empty?)
#      @recapiti = @recapiti.where("cda_telefono like '%#{tel}%' ") if (tel and not tel.empty?)
#      @recapiti = @recapiti.to_a

  def tel
    @recapiti = Recapito.where("cda_cognome like '%#{request.GET[:cognome]}%' ").order(:cda_cognome).to_a
    respond_to do |format|
      format.js {
         respond_with @recapiti.collect{|u| "#{u.cda_nome} #{u.cda_cognome}: #{u.cda_telefono}"}.join(',')
      }
    end
  end

  # Da usarsi con dhtmlxGrid
  def data
    @recapiti = Recapito.all.to_a
  end

  def dbaction
      #called for all db actions
      nome      = params["c0"]
      cognome   = params["c1"]
      telefono  = params["c2"]
      cellulare = params["c3"]
      email     = params["c4"]

      @mode = params["!nativeeditor_status"]
     
      @id = params["gr_id"]
      case @mode
          when "inserted"
              recapito = Recapito.new
              recapito.cda_nome = nome
              recapito.cda_cognome = cognome
              recapito.cda_telefono = telefono
              recapito.cda_cellulare = cellulare
              recapito.cda_email = email
              recapito.save!
              @tid = recapito.prg_id
          when "deleted"
            puts "GRID ID =========================== >>>> #{@id.to_i}"
              recapito = Recapito.find_by_prg_id(@id.to_i)
              recapito.destroy
              @tid = @id
          when "updated"
              recapito = Recapito.find_by_prg_id(@id.to_i)
              recapito.cda_nome = nome
              recapito.cda_cognome = cognome
              recapito.cda_telefono = telefono
              recapito.cda_cellulare = cellulare
              recapito.cda_email = email
              recapito.save!
              @tid = @id
      end
  end

  def rubrica_data_grid
    page = (params[:page]).to_i
    rp = (params[:rp]).to_i
    query = params[:query]
    qtype = params[:qtype]
    sortname = params[:sortname]
    sortorder = params[:sortorder]

    sortname ||= "cda_cognome"
    sortorder ||= "asc"
    page ||= 1
    rp ||= 10

    start = ((page-1) * rp).to_i
    query = "%"+query+"%"

    # No search terms provided
    if(query == "%%")
      @recapiti = Recapito.find(:all, :order => sortname+' '+sortorder, :limit => rp, :offset => start)
      count = Recapito.count(:all)
    else
      @recapiti = Recapito.find(:all, :order => sortname+' '+sortorder, :limit => rp, :offset => start, :conditions=>[qtype +" like ?", query])
      count = Recapito.count(:all, :conditions=>[qtype +" like ?", query])
    end

    # Construct a hash from the ActiveRecord result
    return_data = Hash.new()
    return_data[:page] = page
    return_data[:total] = count

    return_data[:rows] = @recapiti.collect{|u| { :cell=>[u.cda_nome, u.cda_cognome, u.cda_telefono, u.cda_cellulare, u.cda_email] } }

    # Convert the hash to a json object
    render :text=>return_data.to_json, :layout=>false
  end

end
