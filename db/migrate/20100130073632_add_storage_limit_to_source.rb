class AddStorageLimitToSource < ActiveRecord::Migration
  def self.up
    add_column :sources, :storage_limit, :integer
  end

  def self.down
    remove_column :sources, :storage_limit
  end
end
