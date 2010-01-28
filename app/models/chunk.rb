require 'ftools'

class Chunk < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :begin, :end
  validate :end_is_after_begin
  validate :records_available

  after_create :check_file_status
  before_destroy :delete_file

  def title
    read_attribute(:title) or default_title
  end

  def default_title
    "Extrait du #{I18n.localize self.begin}"
  end

  def duration
    if self.begin and self.end
      self.end - self.begin
    end
  end

  def records
    if self.begin and self.end
      Record.uniq self.source.records.including(self.begin, self.end)
    else
      []
    end
  end

  cattr_writer :storage_directory
  def self.storage_directory
    unless @@storage_directory
      @@storage_directory = "#{Rails.root}/tmp/chunks"
    end

    FileUtils.mkdir_p @@storage_directory unless File.exists?(@@storage_directory)
    @@storage_directory
  end

  def file
    filename if File.exist?(filename)
  end

  def size
    file ? File.size(file) : 0
  end

  def filename
    @filename ||= "#{Chunk.storage_directory}/#{self.id}.wav"
  end

  def create_file!
    logger.info "Create file for Chunk #{id}"
    update_attribute :completion_rate, 0

    if Sox.command do |sox|
        records.each do |record|
          sox.input record.filename
        end
        sox.output filename
        sox.effect :trim, self.begin - records.first.begin, duration
      end
      logger.info "Completed file for Chunk #{id}: #{filename}"
      update_attribute :completion_rate, 1.0
    end
  ensure
    unless status.completed?
      logger.info "Failed to create file for Chunk #{id}"
      update_attribute :completion_rate, nil 
    end
  end

  def complete_with(file)
    update_attribute :completion_rate, 0
    if File.copy(file, filename)
      update_attribute :completion_rate, 1.0
    else
      update_attribute :completion_rate, nil
    end
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

  private

  def end_is_after_begin
    if self.duration and self.duration <= 0
      errors.add(:end, :before_begin) 
    end
  end

  def records_available
    unless source.nil? or source.records.empty?
      last_record = source.records.last

      if self.end < last_record.end and self.records.empty?
        errors.add(:begin, :no_record) 
        errors.add(:end, :no_record)
      end
    end
  end
    
end
