# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

 class BusinessExtension < Radiant::Extension
   version "1.0" 
   description "Business Extension" 
   url "http://rubidine.com" 

   define_routes do |map|
     map.resources :businesses, :path_prefix => "/admin"
     map.resources :categories, :path_prefix => "/admin"
     map.resources :events, :path_prefix => "/admin"
     map.resources :tags, :path_prefix => "/admin"
     map.resources :additional_locations, :path_prefix => "/admin"
     map.with_options(:controller => 'businesses') do |business|
       #business.add_location "/admin/businesses/:id/new_location", :action => 'new_location'
     end
     map.resources :businesses
     map.resources :additional_locations
     #map.namespace :businesses do |businesses|
     #  businesses.resources( :member => { :add_location => :post } )
     #end
     map.connect 'businesses/:action/:id', :controller=>'businesses'
     map.connect 'additional_locations/:action/:id', :controller=>'additional_locations'
   #   map.connect 'admin/business_extension/:action', :controller => 'admin/business_extension'
   end

   def activate
     Page.send :include, BusinessTags
     Page.send :include, EventTags
     Page.send :include, CategoryTags
     Page.send :include, LabelTags
     Page.send :include, AdditionalLocationTags
     admin.tabs.add "Businesses", "/admin/businesses", :after => "Layouts", :visibility => [:all]
     admin.tabs.add "Events", "/admin/events", :after => "Layouts", :visibility => [:all]
     admin.tabs.add "Categories/Labels", "/admin/categories", :after => "Layouts", :visibility => [:all]
   
   end

   def deactivate
     # admin.tabs.remove "Business Extension" 
   end

end
