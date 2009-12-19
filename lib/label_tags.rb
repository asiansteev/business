module LabelTags
  include Radiant::Taggable
  include Geokit::Geocoders
  desc %{
    This tag allows you to access a label's information.  It is a container
    for other tags like name and id and businesses.  Find by the id.
  }
  tag 'label' do |tag|
    tag.locals.label = tag.globals.label
    tag.expand
  end

  desc %{
    Cycles through each label.

    *Usage:*
    <r:label:each>
    ...
    </r:label:each>
  }
  tag 'label:each' do |tag|
    result = []
    Tag.find(:all, :order => 'name ASC').each do |t|
      tag.locals.label = t
      result << tag.expand
    end
    result
  end

  tag 'label:each:label' do |tag|
    label = tag.locals.label
    label.name
  end

  tag 'label:each_business' do |tag|
    result = [] 
    businesses = Business.find_tagged_with("'#{tag.locals.label}'")
    if businesses.empty?
      businesses = Business.find_tagged_with("'#{tag.locals.cat_label}'")
    end
    businesses.sort!{|x, y| x.name <=> y.name}
    businesses.each do |b|
      tag.locals.business = b
      result << tag.expand
    end
    result 
  end
  
  [
    'id',
    'name',
    'slug'
  ].each do |t|
    desc %{ Renders the label's #{t}}
    tag "label:#{t}" do |tag|
      unless tag.locals.label.nil?
        tag.locals.label.send(t)
      else
        tag.locals.cat_label.send(t)
      end
    end
  end

  desc %{ Renders a Google Map of the label's business }
  tag "label:gmap" do |tag|
    map = GoogleMap.new
    Business.find_tagged_with("\"#{tag.locals.label.send("name")}\"").each do |b|
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
    m = ''
    m << map.to_html
    m << "<div style=\"width: 500px; height: 500px;\">"
    m << map.div
    m << "</div>"
  end

end
