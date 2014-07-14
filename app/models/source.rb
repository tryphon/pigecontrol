class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :storage_limit, :greater_than_or_equal => 0

  has_many :chunks, :dependent => :destroy
  has_many :labels, :dependent => :destroy

  before_validation :set_default_storage_limit

  def set_default_storage_limit
    self.storage_limit ||= 0
  end

  def self.default
    find_or_create_by_name 'default'
  end

  def self.find_or_default(id)
    id.to_i == 1 ? default : find(id)
  end

  def default_chunk
    if last_record = record_index.last_record
      logger.debug "Use #{last_record.inspect} for default_chunk times"
      chunks.build do |chunk|
        beginning_of_last_hour = last_record.end.change(:min => 0)

        chunk.begin = beginning_of_last_hour
        chunk.end = last_record.end
      end
    end
  end

  def can_store?(chunk)
    chunk.size and remaining_storage_space > chunk.size
  end

  def remaining_storage_space
    spaces = [ free_space ]
    unless storage_limit.nil? or storage_limit.zero?
      spaces << storage_limit - chunks.collect(&:size).sum
    end
    spaces.min
  end

  def free_space
    # TODO the storage directory should be specific to the source
    free_block, block_size = `stat --file-system --printf="%a %S" #{Chunk.storage_directory}`.split.collect(&:to_i)
    free_block*block_size
  end

  def record_index
    @record_index ||= Pige::Record::Index.new
  end

end
