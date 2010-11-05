class AddLimitsToText < ActiveRecord::Migration
  def self.up
  	change_column :pointmaps, :kml, :text, :limit => 10.megabyte
  	change_column :pointmaps, :csv, :text, :limit => 10.megabyte
  end

  def self.down
  end
end
