class Category < ActiveRecord::Base
  acts_as_taggable
  slug_from :name
end
