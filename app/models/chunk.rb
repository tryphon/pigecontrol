class Chunk < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :begin, :end, :completion_rate

  def after_initialize
    self.completion_rate ||= 0
  end

  def records
    if self.begin and self.end
      self.source.records.including(self.begin, self.end)
    else
      []
    end
  end

  def self.storage_directory
    unless @storage_directory
      @storage_directory = "#{Rails.root}/tmp/chunks"
      FileUtils.mkdir_p @storage_directory
    end

    @storage_directory
  end

  def file
    filename if File.exist?(filename)
  end

  def filename
    @filename ||= "#{Chunk.storage_directory}/#{self.id}.wav"
  end

  def create_file!
    if Sox.command do |sox|
        records.each do |record|
          sox.input record.filename
        end
        sox.output filename
      end
      update_attribute :completion_rate, 1.0
    end
  end

  def completed?
    completion_rate >= 1.0
  end

end
