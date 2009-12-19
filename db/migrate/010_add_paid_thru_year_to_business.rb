class AddPaidThruYearToBusiness < ActiveRecord::Migration
  def self.up
    add_column :businesses, :paid_thru_year, :int
  end
  def self.down
    remove_column :businesses, :paid_thru_year
  end
end
