class GruppiController < ApplicationController

	respond_to :html, :xml, :json

  # GET /gruppi
  # GET /gruppi.xml
  def index
    @gruppi = Gruppo.all :order => 'GRP_NAME asc'
    respond_with(@gruppi)
  end

  # GET /gruppi/1
  # GET /gruppi/1.xml
  def show
    @gruppo = Gruppo.find(params[:id])
    respond_with(@gruppo)
  end

end
