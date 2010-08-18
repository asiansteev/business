module EventTags
  include Radiant::Taggable
  desc %{
    This tag allows you to access an event's information.  It is a container
    for other tags like name, description, etc.  Find the event by the id.
  }
  tag 'event' do |tag|
    unless tag.locals.event
      tag.locals.event = tag.globals.event
    end
    tag.expand
  end

  #itterate over all events
  desc %{
    Cycles through each event.

    *Usage:*
    <r:event:each>
      ...
    </r:event:each>
  }
  tag 'event:each' do |tag|
    result = []
    Event.find(:all, :order => 'name ASC', :conditions => ["DATE(date) >= DATE(?)", Time.now]).each do |event|
      tag.locals.event = event 
      result << tag.expand
    end
    result
  end

  tag 'event:each:event' do |tag|
    event = tag.locals.event
    event.name
  end

  [
    'id',
    'name',
    'where',
    'description',
    'date',
    'time'
  ].each do |t|
    desc %{ Renders the event's #{t}}
    tag "event:#{t}" do |tag|
    p t
      if t == 'date'
    
        tag.locals.event.send(t).strftime("%A, %b. %d")
      else
        tag.locals.event.send(t)
      end
    end
  end

end
