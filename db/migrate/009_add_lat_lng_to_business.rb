class AddLatLngToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :lat, :float
    add_column :businesses, :lng, :float
  end
  def self.down
    remove_column :businesses, :lat
    remove_column :businesses, :lng
  end
end
