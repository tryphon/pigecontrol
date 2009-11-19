class Chunk < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :begin, :end

  after_create :check_file_status
  before_destroy :delete_file

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
    update_attribute :completion_rate, 0

    if Sox.command do |sox|
        records.each do |record|
          sox.input record.filename
        end
        sox.output filename
      end
      update_attribute :completion_rate, 1.0
    end
  ensure
    update_attribute :completion_rate, nil unless status.completed?
  end

  def check_file_status
    if status.created?
      send_later :create_file!
    end
  end

  def delete_file
    File.delete(file) if file
  end

  def status
    string_value = case completion_rate 
    when nil
      "created"
    when 1.0
      "completed"
    else
      "pending"
    end
    ActiveSupport::StringInquirer.new(string_value)
  end

end
