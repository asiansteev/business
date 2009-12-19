class AddBusinessTable < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.column :name, :string
      t.column :short_description, :string
      t.column :address_line_1, :string
      t.column :address_line_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :phone, :string
      t.column :email, :string
      t.column :url, :string
      t.column :description, :string
    end
  end

  def self.down
    drop_table :businesses
  end
end
