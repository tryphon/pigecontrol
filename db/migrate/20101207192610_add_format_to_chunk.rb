class AddFormatToChunk < ActiveRecord::Migration
  def self.up
    add_column :chunks, :format, :string
  end

  def self.down
    remove_column :chunks, :format
  end
end
