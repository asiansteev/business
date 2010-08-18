class BusinessesController < ApplicationController
  # GET /businesses
  # GET /businesses.xml
  def index
    @businesses = Business.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @businesses }
    end
    #render :layout => false
  end

  # GET /businesses/1
  # GET /businesses/1.xml
  def show
    @business = Business.find_by_slug(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/new
  # GET /businesses/new.xml
  def new
    @business = Business.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @business }
    end
  end

  # GET /businesses/1/edit
  def edit
    @business = Business.find_by_slug(params[:id])
  end

  # POST /businesses
  # POST /businesses.xml
  def create
    @business = Business.new(params[:business])

    if @business.save
      flash[:notice] = 'Business was successfully created.'
      redirect_to(@business)
    else
      flash[:error] = 'Business was NOT successfully created.'
      render :action => "new"
    end
  end

  # PUT /businesses/1
  # PUT /businesses/1.xml
  def update
    @business = Business.find_by_slug(params[:id])
    params[:business].each do |p|
      if p.first.to_s.match(/tagged_(.+)[^=]$/)
        tag = p.first.to_s.split('_')[1]
        if (p[1]) == '1'
          @business.tag_list.add(tag)
        else
          @business.tag_list.remove(tag)
        end
        @business.save
      else
        @business.update_attribute(p[0], p[1])
        @business.save
      end
    end
    redirect_to business_url
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.xml
  def destroy
    @business = Business.find_by_slug(params[:id])
    @business.destroy

    redirect_to businesses_url
  end

  def add_year
    @business = Business.find params[:id]
    @business.paid_thru_year = @business.paid_thru_year + 1
    if @business.save
      flash[:notice] = "1 Year Added to #{@business.name}"
    else
      flash[:error] = "Failed to Add Year to #{@business.name}"
    end
    redirect_to businesses_url
  end

end
