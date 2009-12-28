class AddTitleToChunks < ActiveRecord::Migration
  def self.up
    add_column :chunks, :title, :string
  end

  def self.down
    remove_column :chunks, :title
  end
end
