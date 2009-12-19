class AddBusinessIdToAdditionalLocation < ActiveRecord::Migration
  def self.up
    add_column :additional_locations, :business_id, :integer
  end
  def self.down
    remove_column :additional_locations, :business_id
  end
end
