class AddIndexOnRecordFilename < ActiveRecord::Migration
  def self.up
    add_index :records, :filename
  end

  def self.down
    remove_index :records, :filename
  end
end
