class AddOilSpill < ActiveRecord::Migration
  def self.up
  	add_column :pointmaps, :oil_spill, :boolean
  end

  def self.down
  	remove_column :pointmaps, :oil_spill
  end
end
