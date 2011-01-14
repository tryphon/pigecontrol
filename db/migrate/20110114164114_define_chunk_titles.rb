class DefineChunkTitles < ActiveRecord::Migration
  def self.up
    Chunk.find_each do |chunk|
      chunk.update_attribute :title, chunk.default_title if chunk.title.blank?
    end
  end

  def self.down

  end
end
