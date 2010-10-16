class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.string :name
      t.string :url
      t.string :checksum
      t.string :description_url
      t.string :status
      t.datetime :status_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :releases
  end
end
