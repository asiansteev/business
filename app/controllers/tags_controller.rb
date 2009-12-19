class TagsController < ApplicationController

  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tag }
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find_by_slug(params[:id])
  end

  # POST /tags
  # POST /tags.xml
  def create
    @tag = Tag.new(params[:tag])

    respond_to do |format|
      if @tag.save
        flash[:notice] = 'Tag was successfully created.'
        format.html { redirect_to(categories_path) }
        format.xml  { render :xml => @tag, :status => :created, :location => @tag }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tag.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  def update
    @tag = Tag.find_by_slug(params[:id])
    params[:tag].each do |p|
      if p.first.to_s.match(/of_category_(.+)[^=]$/)
        cat_name = p.first.to_s.split('_')[2]
        @category = Category.find_by_name(cat_name)
        if (p[1]) == '1'
          @category.tag_list.add(@tag.name)
        else
          @category.tag_list.remove(@tag.name)
        end
        @category.save
      else
        @tag.update_attribute(p[0], p[1])
      end
    end
    redirect_to(categories_url)
  end

  # DELETE /tags/1
  def destroy
    @tag = Tag.find_by_slug(params[:id])
    @tag.destroy

    redirect_to(categories_url)
  end

  def add_tag
    @tag = Tag.find_by_slug(params[:id])
  end
end
