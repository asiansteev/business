class Business < ActiveRecord::Base
  include Geokit::Geocoders
  has_many :additional_locations
  acts_as_taggable
  slug_from :name
  before_save :set_coordinates

  def add_tag
  end

  def add_tag= tag
    operation = tag.split(':')[0]
    tag_name = tag.split(':')[1]
    #puts tag_name
    if operation == 'add'
      tag_list.add(tag_name)
    elsif operation == 'remove'
      tag_list.remove(tag_name)
    end
  end

  def address
    "#{address_line_1}, #{city}, #{state}"
  end

  def method_missing(meth, *args)
    # method named tagged_foo and doesn't end in '=' (a reader)
    if match = meth.to_s.match(/tagged_(.+)[^=]$/)
      # call to reader
      tags.each do |t|
        if t.name == meth.to_s.split('_')[1]
          return true
        end
      end
      false
    # method named tagged_foo and ends in '=' (a writer)
    elsif match = meth.to_s.match(/^tagged_(.+)=$/)
      # call to writer
      tag = meth.to_s.split('_')[1].chop
      if (args[0] == '1')
        self.tag_list.add(tag)
      else 
        self.tag_list.remove(tag)
      end
    else
      super
    end
  end

  private

  ##
  # Sets the coordinates for a business.
  #
  def set_coordinates
    addrs = [
      "#{address_line_1}",
      "#{address_line_2}",
      "#{address_line_1}, #{address_line_2}"
    ]
    catch(:geocoded) do
      addrs.each do |addr|
        begin
          loc = MultiGeocoder.geocode(
            "#{addr}, #{city}, #{state} #{zip}"
          )
          if loc.success
            self.lat = loc.lat
            self.lng = loc.lng
            throw :geocoded
          end

        rescue Exception => ex
          puts " -> #{addr} did not resolve"
          puts " -> #{ex.message}"
        end
      end
      puts "did not match any combination of address1 and address2"
    end
  end

end
