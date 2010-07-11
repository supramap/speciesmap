class PointmapsController < ApplicationController
  before_filter :require_user
  before_filter :editable, :only => [:edit, :destroy, :update]
  before_filter :viewable, :only => [:show, :download]

  # GET /depthmaps
  # GET /depthmaps.xml
  def index
    @pointmaps = Pointmap.find(:all, :conditions => ["user_id = ? OR public = ?", current_user.id, true])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pointmaps }
    end
  end

  # GET /depthmaps/1
  # GET /depthmaps/1.xml
  def show
    @pointmap = Pointmap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @pointmap }
    end
  end

  # GET /depthmaps/new
  # GET /depthmaps/new.xml
  def new
    @pointmap = Pointmap.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @pointmap }
    end
  end

  # GET /depthmaps/1/edit
  def edit
    @pointmap = Pointmap.find(params[:id])
  end

  # POST /depthmaps
  # POST /depthmaps.xml
  def create
    params[:pointmap][:csv] = params[:pointmap][:csv].read if params[:pointmap][:csv]
    @pointmap = Pointmap.new(params[:pointmap])
    @pointmap.writeKml

    respond_to do |format|
      if @pointmap.save
        flash[:notice] = "#{@pointmap.name} was successfully created."
        format.html { redirect_to(@pointmap) }
        format.xml  { render :xml => @pointmap, :status => :created, :location => @pointmap }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @pointmap.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /depthmaps/1
  # PUT /depthmaps/1.xml
  def update
    params[:pointmap][:csv] = params[:pointmap][:csv].read if params[:pointmap][:csv]
    @pointmap = Pointmap.find(params[:id])
    @pointmap.writeKml

    respond_to do |format|
      if @pointmap.update_attributes(params[:pointmap])
        flash[:notice] = "#{@pointmap.name} was successfully updated."
        format.html { redirect_to(@pointmap) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pointmap.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /depthmaps/1
  # DELETE /depthmaps/1.xml
  def destroy
    @pointmap = Pointmap.find(params[:id])
    flash[:notice] = "#{@pointmap.name} was successfully deleted."
    @pointmap.destroy

    respond_to do |format|
      format.html { redirect_to(depthmaps_url) }
      format.xml  { head :ok }
    end
  end

  def download_kml
  	@pointmap = Pointmap.find(params[:id])
  	send_data @pointmap.kml, :filename => "#{@pointmap.name}.kml", :type => "application/vnd.google-earth.kml+xml"
  end

  def download_csv
    @pointmap = Pointmap.find(params[:id])
  	send_data @pointmap.csv, :filename => "#{@pointmap.name}.csv", :type => "text/csv"
  end
end
