class ChangeKmlToTextAndAddCsv < ActiveRecord::Migration
  def self.up
  	add_column :pointmaps, :csv, :text
  	change_column :pointmaps, :kml, :text
  end

  def self.down
  	remove_column :pointmaps, :csv
  	change_column :pointmaps, :kml, :binary
  end
end
