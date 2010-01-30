class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :storage_limit, :greater_than_or_equal => 0

  has_many :chunks, :dependent => :destroy
  has_many :records, :dependent => :destroy, :order => "begin"
  has_many :labels, :dependent => :destroy

  def before_validation
    self.storage_limit ||= 0
  end

  def self.default
    find_or_create_by_name 'default'
  end

  def default_chunk
    unless records.empty?
      chunks.build.tap do |chunk|
        beginning_of_last_hour = records.last.end.change(:min => 0)
        chunk.begin = [beginning_of_last_hour, records.first.begin].max
        chunk.end = records.last.end
      end
    end
  end
  
  def can_store?(chunk)
    chunk.size and remaining_storage_space > chunk.size
  end

  def remaining_storage_space
    if storage_limit.nil? or storage_limit.zero?
      free_space
    else
      storage_limit - chunks.collect(&:size).sum
    end
  end

  def free_space
    # TODO the storage directory should be specific to the source
    free_block, block_size = `stat --file-system --printf="%a %S" #{Chunk.storage_directory}`.split.collect(&:to_i)
    free_block*block_size
  end

end
