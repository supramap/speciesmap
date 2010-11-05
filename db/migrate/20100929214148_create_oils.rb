class CreateOils < ActiveRecord::Migration
  def self.up
    create_table :oils do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :oils
  end
end
