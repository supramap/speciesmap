class CreateOilKMLs < ActiveRecord::Migration
  def self.up
    create_table :oil_kmls do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :oil_kmls
  end
end
