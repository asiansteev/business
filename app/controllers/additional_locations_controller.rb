class AdditionalLocationsController < ApplicationController
  # GET /additional+location/new
  def new
    @additional_location = AdditionalLocation.new
    @business = Business.find(params[:business_id])
  end

  # POST /additional_locations
  # POST /additional_locations.xml
  def create
    @business = Business.find(params[:business][:id])
    @additional_location = AdditionalLocation.new(params[:additional_location])

    respond_to do |format|
      if @additional_location.save
        @business.additional_locations << @additional_location
        flash[:notice] = 'Additional Location was successfully created.'
        format.html { redirect_to(@business) }
        format.xml  { render :xml => @business, :status => :created, :location => @business }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @additional_location.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @location = AdditionalLocation.find(params[:id])
    @business = Business.find(@location.business_id)
    
    respond_to do |format|
      if @location.update_attributes(params[:additional_location])
        flash[:notice] = 'Additional Address was successfully created.'
        format.html { redirect_to(@business) }
        format.xml  { render :xml => @business, :status => :created, :location => @business }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @business.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /additional_locations/1/edit
  def edit
    @location = AdditionalLocation.find(params[:id])
    @business = Business.find(@location.business_id)
  end

  # DELETE /additional_locations/1
  # DELETE /additional_locations/1.xml
  def destroy
    @location = AdditionalLocation.find(params[:id])
    @business = Business.find(@location.business_id)
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(@business) }
      format.xml  { head :ok }
    end
  end

end
