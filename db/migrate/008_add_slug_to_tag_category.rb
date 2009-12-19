class AddSlugToTagCategory < ActiveRecord::Migration
  def self.up
    add_column :tags, :slug, :string
    add_column :categories, :slug, :string
  end
  def self.down
    remove_column :tags, :slug
    remove_column :categories, :slug
  end
end
