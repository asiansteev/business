module CategoryTags
  include Radiant::Taggable
  include Geokit::Geocoders

  desc %{
    This tag allows you to access a category's information.  It is a container
    for other tags like name and id and businesses.  Find by the id.
  }
  tag 'category' do |tag|
    tag.locals.category = tag.globals.category
    tag.expand
  end

  desc %{
    Cycles through each category.

    *Usage:*
    <r:category:each>
    ...
    </r:category:each>
  }
  tag 'category:each' do |tag|
    result = []
    Category.find(:all, :order => 'name ASC').each do |c|
      tag.locals.category = c
      result << tag.expand
    end
    result
  end

  tag 'category:each:category' do |tag|
    category = tag.locals.category
    category.name
  end

  tag 'category:each_label' do |tag|
    result = [] 
    labels = tag.locals.category.tags
    labels.each do |l|
      unless Business.find_tagged_with("\"#{l}\"").empty?
        tag.locals.cat_label = l
        result << tag.expand
      end
    end
    result 
  end
  
  [
    'id',
    'name',
    'slug'
  ].each do |t|
    desc %{ Renders the category's #{t}}
    tag "category:#{t}" do |tag|
      tag.locals.category.send(t)
    end
  end

  desc %{ Renders a Google Map of the category's business }
  tag "category:gmap" do |tag|
    map = GoogleMap.new
    tag.locals.category.tags.each do |t|
      Business.find_tagged_with("\"#{t.name}\"").each do |b|
        if map.markers.length < 20
          if b.lat
            map.markers << GoogleMapMarker.new(:map => map,
                                          :lat => b.lat,
                                          :lng => b.lng,
                                          :html => "<h2>#{b.name}</h2>
                                                #{b.address_line_1}<br />
                                                #{b.city}, #{b.state} #{b.zip}"
                                            )
          end
        end
      end
    end
    m = ''
    m << map.to_html
    m << "<div style=\"width: 500px; height: 500px;\">"
    m << map.div
    m << "</div>"
  end
end
