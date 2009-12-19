module BusinessTags
  include Radiant::Taggable
  include Geokit::Geocoders
  desc %{
    This tag allows you to access a business's information.  It is a container
    for other tags like name, description, etc.  Find the business by the id.
  }
  tag 'business' do |tag|
    unless tag.locals.business
      tag.locals.business = tag.globals.business
    end
    tag.expand
  end

  #itterate over all businesses
  desc %{
    Cycles through each business.

    *Usage:*
    <r:business:each>
      ...
    </r:business:each>
  }
  tag 'business:each' do |tag|
    result = []
    Business.find(:all, :order => 'name ASC').each do |business|
      tag.locals.business = business 
      result << tag.expand
    end
    result
  end

  tag 'business:each:business' do |tag|
    business = tag.locals.business
    # %{<a href="#{business.url}" title="#{business.description}">#{business.title}</a>}
    business.name
  end

  [
    'id',
    'name',
    'short_description',
    'address_line_1',
    'address_line_2',
    'city',
    'state',
    'zip',
    'phone',
    'email',
    'url',
    'description',
    'tag_list',
    'phone_2',
    'url_2',
    'slug'
  ].each do |t|
    desc %{ Renders the business's #{t}}
    tag "business:#{t}" do |tag|
      tag.locals.business.send(t)
    end
  end

  [ 'address_line_1',
    'address_line_2',
    'email',
    'url',
    'url_2',
    'phone_2'
  ].each do |t|
    desc %{
      If #{t} exists for this business, expand this tag.
    }
    tag "business:if_#{t}" do |tag|
      thing = tag.locals.business.send(t)
      unless thing.nil? || thing.empty?
        tag.expand
      else
        ''
      end
    end
  end 

  #itterate over all additional locations
  desc %{
    Cycles through each additional location for this business.

    *Usage:*
    <r:business>
      <r:each_additional_location>
        ...
      </r:each_additional_location>
    </r:business>
  }
  tag "business:each_additional_location" do |tag|
    result = []
    b = tag.locals.business
    b.additional_locations.each do |loc|
      tag.locals.additional_location = loc
      result << tag.expand
    end
    result
  end

  desc %{ Renders a Google Map of the business }
  tag "business:gmap" do |tag|
    map = GoogleMap.new
    b = tag.locals.business 
    if b.lat
      b = tag.locals.business 
      map.markers << GoogleMapMarker.new(:map => map,
                                       :lat => b.lat,
                                       :lng => b.lng,
                                       :html => "<h2>#{b.name}</h2>
                                                 #{b.address_line_1}<br />
                                                 #{b.city}, #{b.state} #{b.zip}"
                                       )
      m = ''
      m << map.to_html
      m << "<div style=\"width: 500px; height: 500px;\">"
      m << map.div
      m << "</div>"
    else
      nil
    end
  end

end
