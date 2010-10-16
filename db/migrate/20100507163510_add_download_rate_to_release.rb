class AddDownloadRateToRelease < ActiveRecord::Migration
  def self.up
    add_column :releases, :download_size, :integer
    add_column :releases, :url_size, :integer
  end

  def self.down
    remove_column :releases, :download_size
    remove_column :releases, :url_size
  end
end
