class CreatePointmaps < ActiveRecord::Migration
  def self.up
    create_table :pointmaps do |t|
      t.string :name
      t.string :description
      t.binary :kml
      t.boolean :public
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :pointmaps
  end
end
