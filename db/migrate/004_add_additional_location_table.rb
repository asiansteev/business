class AddAdditionalLocationTable < ActiveRecord::Migration
  def self.up
    create_table :additional_locations do |t|
      t.column :address_line_1, :string
      t.column :address_line_2, :string
      t.column :city, :string
      t.column :state, :string
      t.column :zip, :string
      t.column :phone, :string
      t.column :phone_2, :string
    end
  end

  def self.down
    drop_table :additional_locations
  end
end
