module AdditionalLocationTags
  include Radiant::Taggable
  
  desc %{
    This tag allows you to access an additional location's information.  It is 
    a container for other tags like city, state, etc.  Find the location by the
    id.
  }
  tag 'additional_location' do |tag|
    unless tag.locals.additional_location
      tag.locals.additional_location = tag.globals.additional_location
    end
    tag.expand
  end

  [
    'id',
    'address_line_1',
    'address_line_2',
    'city',
    'state',
    'zip',
    'phone',
  ].each do |t|
    desc %{ Renders the additional location's #{t}}
    tag "additional_location:#{t}" do |tag|
      tag.locals.additional_location.send(t)
    end
  end

  [ 'address_line_2',
  ].each do |t|
    desc %{
      If #{t} exists for this additional location, expand this tag.
    }
    tag "additional_location:if_#{t}" do |tag|
      thing = tag.locals.additional_location.send(t)
      unless thing.nil? || thing.empty?
        tag.expand
      else
        ''
      end
    end
  end 

end
