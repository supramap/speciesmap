class PointmapsController < ApplicationController
  before_filter :require_user
  before_filter :editable, :only => [:edit, :destroy, :update]
  before_filter :viewable, :only => [:show, :download]

  # GET /pointmaps
  # GET /pointmaps.xml
  def index
    @pointmaps = Pointmap.find(:all, :conditions => ["user_id = ? OR public = ?", current_user.id, true])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pointmaps }
    end
  end

  # GET /pointmaps/1
  # GET /pointmaps/1.xml
  def show
    @pointmap = Pointmap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pointmap }
    end
  end

  # GET /pointmaps/new
  # GET /pointmaps/new.xml
  def new
    @pointmap = Pointmap.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pointmap }
    end
  end

  # GET /pointmaps/1/edit
  def edit
    @pointmap = Pointmap.find(params[:id])
  end

  # POST /pointmaps
  # POST /pointmaps.xml
  def create
    @pointmap = Pointmap.new(params[:pointmap])
    @pointmap.csv = params[:pointmap][:csv].read
    @pointmap.writeKml

    respond_to do |format|
      if @pointmap.save
        flash[:notice] = 'Pointmap was successfully created.'
        format.html { redirect_to(@pointmap) }
        format.xml  { render :xml => @pointmap, :status => :created, :location => @pointmap }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pointmap.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pointmaps/1
  # PUT /pointmaps/1.xml
  def update
    @pointmap = Pointmap.find(params[:id])
    @pointmap.csv = params[:pointmap][:csv].read
    @pointmap.writeKml

    respond_to do |format|
      if @pointmap.update_attributes(params[:pointmap])
        flash[:notice] = 'Pointmap was successfully updated.'
        format.html { redirect_to(@pointmap) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pointmap.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pointmaps/1
  # DELETE /pointmaps/1.xml
  def destroy
    @pointmap = Pointmap.find(params[:id])
    @pointmap.destroy

    respond_to do |format|
      format.html { redirect_to(pointmaps_url) }
      format.xml  { head :ok }
    end
  end

  def download_kml
  	@pointmap = Pointmap.find(params[:id])
  	data = Tempfile.new('pointmap')
  	data.write(@pointmap.kml)
  	send_file data.path, :filename => "#{@pointmap.name}.kml", :type => "application/vnd.google-earth.kml+xml"
  end

  def download_csv
  @pointmap = Pointmap.find(params[:id])
  	data = Tempfile.new('pointmap')
  	data.write(@pointmap.csv)
  	send_file data.path, :filename => "#{@pointmap.name}.csv", :type => "text/csv"
  end
end
