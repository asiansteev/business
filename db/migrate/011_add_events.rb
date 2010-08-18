class AddEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :name, :string
      t.column :where, :string
      t.column :description, :string
      t.column :date, :date
      t.column :time, :string
    end
  end

  def self.down
    drop_table :events
  end
end
