class AddSlugToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :slug, :string
  end
  def self.down
    remove_column :businesses, :slug
  end
end
