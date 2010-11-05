class CreateFishKMLs < ActiveRecord::Migration
  def self.up
    create_table :fish_kmls do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fish_kmls
  end
end
