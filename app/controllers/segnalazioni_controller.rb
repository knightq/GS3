class SegnalazioniController < ApplicationController

  layout "application", :except => :gsprg
  respond_to :html, :xml, :json, :rdf
  before_filter :require_user, :except => [:show, :gsprg]
  before_filter :find_project, :only => [:new, :create]
  helper :sort
  include SortHelper
  helper :queries
  include QueriesHelper

  # POST /segnalazioni
  # POST /segnalazioni.xml
  def create
    @segnalazione = Segnalazione.new(params[:segnalazione])
    respond_to do |format|
      if @segnalazione.save
        format.html { redirect_to(@segnalazione, :notice => 'Segnalazione inserita con successo.') }
        format.xml  { render :xml => @segnalazione, :status => :created, :location => @segnalazione }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @segnalazione.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show 
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    respond_with @segnalazione 
  end
  
  def update
    nuova_des = params[:s][:des_segna]
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    old_des = @segnalazione.des_segna
    @segnalazione.des_segna = nuova_des
    if(@segnalazione.save)
      SegnalazioniMailer.cambio_descrizione(current_user, @segnalazione, old_des).deliver  
      flash[:notice] = "Segnalazione #{@segnalazione.prg_segna} aggiornata con successo!"
    else 
      flash[:error] = "Aggiornamento fallito!"
    end
    respond_to do |format|
      format.html { }
      format.js {
      }
    end
  end
  
  def index
    retrieve_query
    # sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
    sort_init([['prg_segna', 'desc']])
    sort_update %w(prg_segna)
    #@query = 'sddd'
    @segnalazioni = Segnalazione.paginate(:all, :order => sort_clause, :per_page => 10, :page => params[:page])  
#    sort_update({'id' => "#{Issue.table_name}.id"}.merge(@query.columns.inject({}) {|h, c| h[c.name.to_s] = c.sortable; h}))
#    
#    if @query.valid?
#      limit = per_page_option
#      respond_to do |format|
#        format.html { }
#        format.atom { }
#        format.csv  { limit = Setting.issues_export_limit.to_i }
#        format.pdf  { limit = Setting.issues_export_limit.to_i }
#      end
#      @issue_count = Issue.count(:include => [:status, :prodotto], :conditions => @query.statement)
#      @issue_pages = Paginator.new self, @issue_count, limit, params['page']
#      @issues = Issue.find :all, :order => sort_clause,
#                           :include => [ :assigned_to, :status, :tracker, :prodotto, :priority, :category, :fixed_version ],
#                           :conditions => @query.statement,
#                           :limit  =>  limit,
#                           :offset =>  @issue_pages.current.offset
#      respond_to do |format|
#        format.html { render :template => 'issues/index.rhtml', :layout => !request.xhr? }
#        format.atom { render_feed(@issues, :title => "#{@prodotto || Setting.app_title}: #{l(:label_issue_plural)}") }
#        format.csv  { send_data(issues_to_csv(@issues, @prodotto).read, :type => 'text/csv; header=present', :filename => 'export.csv') }
#        format.pdf  { send_data(issues_to_pdf(@issues, @prodotto), :type => 'application/pdf', :filename => 'export.pdf') }
#      end
#    else
#      # Send html if the query is not valid
#      render(:template => 'issues/index.rhtml', :layout => !request.xhr?)
#    end
#  rescue ActiveRecord::RecordNotFound
#    render_404
  end

  # GET /segnalazioni/new
  # GET /segnalazioni/new.xml
  def new
    @segnalazione = Segnalazione.new
    @segnalazione.dtm_creaz = Date.today
    respond_with @segnalazione
  end
  
  # GET /segnalazioni/1/edit
  def edit
    @segnalazione = Segnalazione.find_by_prg_segna(params[:id])
    respond_with(@segnalazione)
  end
  
  # DELETE /segnalazioni/1
  # DELETE /segnalazioni/1.xml
  def destroy
    @utente = Segnalazione.find_by_prg_segna(params[:id])
    @utente.destroy
    
    respond_to do |format|
      format.html { redirect_to(segnalazioni_url) }
      format.xml  { head :ok }
    end
  end

private
  # Retrieve query from session or build a new query
  def retrieve_query
    if !params[:query_id].blank?
      cond = "cda_prodotto IS NULL"
      cond << " OR cda_prodotto = #{@prodotto.cda_prodotto}" if @prodotto
      @query = Query.find(params[:query_id], :conditions => cond)
      @query.prodotto = @prodotto
      session[:query] = {:id => @query.id, :cda_prodotto => @query.cda_prodotto}
    else
      if params[:set_filter] || session[:query].nil? || session[:query][:cda_prodotto] != (@prodotto ? @prodotto.id : nil)
        # Give it a name, required to be valid
        @query = Query.new(:name => "_")
        @query.prodotto = @prodotto
        if params[:fields] and params[:fields].is_a? Array
          params[:fields].each do |field|
            @query.add_filter(field, params[:operators][field], params[:values][field])
          end
        else
          @query.available_filters.keys.each do |field|
            @query.add_short_filter(field, params[field]) if params[field]
          end
        end
        session[:query] = {:cda_prodotto => @query.cda_prodotto, :filters => @query.filters}
      else
        @query = Query.find_by_id(session[:query][:id]) if session[:query][:id]
        @query ||= Query.new(:name => "_", :prodotto => @prodotto, :filters => session[:query][:filters])
        @query.prodotto = @prodotto
      end
    end
  end

  def gsprg
    gs = request.GET[:q]
    user_id = request.GET[:user_id]
    @gs = Segnalazione.select(:prg_segna).where("prg_segna LIKE '#{gs}%'").limit(request.GET[:limit])
    unless user_id == '-1' 
      @gs = @gs.involved(user_id)
    end
    @gs = @gs.collect{|g| g.prg_segna}
    puts "GS recuperate: #{@gs}"
    respond_with @gs
  end
  
  def find_project
    cda_prodotto = (params[:segnalazione] && params[:segnalazione][:cda_prodotto]) || params[:cda_prodotto]
    @prodotto = Prodotto.find(cda_prodotto)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

end
