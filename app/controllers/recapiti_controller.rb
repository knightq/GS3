require 'active_support/builder' unless defined?(Builder)

class RecapitiController < ApplicationController
	respond_to :html, :xml, :json, :js
  #before_filter :require_user, :except => [:data, :index]

  #protect_from_forgery :except => [:rubrica_data_grid]
 
  # GET /recapiti
  # GET /recapiti.xml
  def index
    puts "FORMATO: #{request.format}"
    if request.format == 'application/json' || request.format == 'text/javascript' then
      cognome = request.GET[:cognome]
      tel = request.GET[:tel]
      @recapiti = Recapito.order(:cda_cognome)
      @recapiti = @recapiti.where("cda_cognome like '%#{cognome}%' ") if (cognome and not cognome.empty?)
      @recapiti = @recapiti.where("cda_telefono like '%#{tel}%' ") if (tel and not tel.empty?)
      @recapiti = @recapiti.to_a
    else
      @recapiti = Recapito.scoped.order(:cda_cognome).to_a
      @recapiti_group = @recapiti.to_a.group_by{ |u| u.cda_cognome.to_s[0..0].upcase }  
    end
    respond_to do |format|
      format.html { puts "------------------ HTML!!!! ----- "; } # show.html.erb
      format.xml { puts "------------------ XML!!!! ----- "; render :xml => @recapiti }
      format.json {
        puts request.GET
        respond_with @recapiti.to_json
      }
      format.js {
        @elenco = @recapiti.collect{|u| "#{u.cda_nome} #{u.cda_cognome}: #{u.cda_telefono}"}.join(', ').to_s
        puts "ELENCO: #{@elenco}"
        respond_with @elenco
      }
    end
  end

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

  # GET /recapiti/1
  # GET /recapiti/1.xml
  def show
    @recapito = Recapito.find_by_prg_id(params[:id])
		respond_with(@recapito)
  end

  # GET /recapiti/new
  # GET /recapiti/new.xml
  def new
    @recapito = Recapito.new
		respond_with(@recapito)
  end

  # GET /recapiti/1/edit
  def edit
    @recapito = Recapito.find_by_prg_id(params[:id])
		respond_with(@recapito)
  end

  # POST /recapiti
  # POST /recapiti.xml
  def create
    @recapito = Recapito.new(params[:recapito])

    respond_to do |format|
      if @recapito.save
        flash[:notice] = 'Recapito was successfully created.'
        format.html { redirect_to(@recapito) }
        format.xml  { render :xml => @recapito, :status => :created, :location => @recapito }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @recapito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /recapiti/1
  # PUT /recapiti/1.xml
  def update
    @recapito = Recapito.find_by_prg_id(params[:id])

    respond_to do |format|
      if @recapito.update_attributes(params[:recapito])
        flash[:notice] = 'Recapito was successfully updated.'
        format.html { redirect_to(@recapito) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @recapito.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /recapiti/1
  # DELETE /recapiti/1.xml
  def destroy
    @recapito = Recapito.find_by_prg_id(params[:id])
    @recapito.destroy

    respond_to do |format|
      format.html { redirect_to(recapiti_url) }
      format.xml  { head :ok }
    end
  end

end
