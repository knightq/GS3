require 'menu_from_PDF'

class MenuController < ApplicationController
  
  respond_to :html

  # GET /menu
  # GET /menu.xml
  def index
    puts "888888888888888888888888888888888888888888888888888888888888888888"
    puts "@menus: #{@menus}"
    puts "params: #{params}"
    puts "888888888888888888888888888888888888888888888888888888888888888888"
    @menus = params[:menus]
    #MenuFromPDF.parse('/home/asalicetti/menu12luglio.pdf')
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /menu/1
  # GET /menu/1.xml
  def show
    #@menu = Menu.find(params[:id])
    puts "#{params}"
    puts "@menu #{@menu}"
    puts "@menus #{@menus}"
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @menu }
    end
  end
  
  # GET /menu/new
  # GET /menu/new.xml
  def new
    @menu_mensa = ::Menu.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def load_menu
    @file = params[:menu][:uploaded_data]
    @menus = Array.new
    puts "-- FILE:  #{@file} --"
    receiver = PDF::Reader::RegisterReceiver.new
    pdf = PDF::Reader.new
    pdf.parse(@file, receiver)
    receiver.callbacks.each do |cb|
      if cb[:name].to_s =~ /show_text/ and not (valore = cb[:args].compact.first.strip).empty? and valore =~ /^[A-Za-z]/ 
        if valore =~ /\d{2}\/\d{2}\/\d{2}$/
          @menu = ::Menu.new(valore)
          @menus << @menu
        else
          @menu.parseRow(valore)         
        end
      end
    end
    puts "Menu caricato!"
    #render :xml => @menus
    #respond_with(@menu, :notice => 'Menu creato con successo!')
    #redirect_to menu_index_path(:menus => @menus)
    render :action => 'index'
  end
  
  # GET /menu/1/edit
  def edit
    @menu = Menu.find(params[:id])
  end
  
  # POST /menu
  # POST /menu.xml
  def create
    @menu = Menu.new(params[:menu])
    
    respond_to do |format|
      if @menu.save
        format.html { redirect_to(@menu, :notice => 'Menu was successfully created.') }
        format.xml  { render :xml => @menu, :status => :created, :location => @menu }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /menu/1
  # PUT /menu/1.xml
  def update
    @menu = Menu.find(params[:id])
    
    respond_to do |format|
      if @menu.update_attributes(params[:menu])
        format.html { redirect_to(@menu, :notice => 'Menu was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /menu/1
  # DELETE /menu/1.xml
  def destroy
    @menu = Menu.find(params[:id])
    @menu.destroy
    
    respond_to do |format|
      format.html { redirect_to(menu_index_url) }
      format.xml  { head :ok }
    end
  end
end
