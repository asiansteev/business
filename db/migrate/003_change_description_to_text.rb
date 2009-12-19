class ChangeDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :businesses, :description, :text
  end
  def self.down
    change_column :businesses, :description, :string
  end
end
