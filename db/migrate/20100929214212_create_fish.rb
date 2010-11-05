class CreateFish < ActiveRecord::Migration
  def self.up
    create_table :fish do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fish
  end
end
