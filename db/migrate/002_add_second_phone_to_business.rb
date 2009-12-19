class AddSecondPhoneToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :phone_2, :string
    add_column :businesses, :url_2, :string
  end
  def self.down
    remove_column :businesses, :phone_2
    remove_column :businesses, :url_2
  end
end
