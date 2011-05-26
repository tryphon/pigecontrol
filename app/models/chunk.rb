require 'ftools'

class Chunk < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :begin, :end, :format
  validate :end_is_after_begin
  validate :records_available
  validate :source_can_store_it
  validates_inclusion_of :format, :in => [:wav, :vorbis, :mp3]

  before_validation_on_create :use_default_title
  after_create :check_file_status
  before_destroy :delete_file

  validates_uniqueness_of :title
  validate :filename_uniqueness

  def self.requires_cbr?(format)
    format == :aacp
  end
  
  def self.requires_quality?(format)
    not requires_cbr? format
  end

  def self.requires_bitrate?(format)
    requires_cbr? format
  end

  def file_extension
    format == :vorbis ? "ogg" : format.to_s
  end

  def default_title
    unless self.begin.nil?
      "#{Chunk.human_name} #{I18n.localize(self.begin, :locale => :fr)}"
    else
      "#{Chunk.human_name} #{self.id}"
    end
  end

  def use_default_title
    self.title = default_title if title.blank?
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
    file ? File.size(file) : estimated_size
  end

  def estimated_size
    duration * 176400 if duration
  end

  def filename
    base = title.present? ? sanitize_filename(title) : id.to_s
    "#{Chunk.storage_directory}/#{base}.#{file_extension}"
  end

  def create_file!
    logger.info "Create file for Chunk #{id}"
    update_attribute :completion_rate, 0

    if Sox.command do |sox|
        records.each do |record|
          sox.input record.filename
        end
        sox.output filename, :compression => file_compression
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

  def file_compression
    format == :mp3 ? -1 : 6
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

  def time_range
    if self.duration and self.duration > 0
      Range.new(self.begin, self.end)
    end
  end

  def format=(format)
    write_attribute :format, format or format.to_s
  end

  def format
    raw_format = read_attribute(:format)
    raw_format ? raw_format.to_sym : :wav
  end

  def presenter
    @presenter ||= ChunkPresenter.new(self)
  end
  
  private

  def filename_uniqueness
    return if errors.on(:title)

    errors.add(:title, :taken) if Chunk.all.any? do |other|
      self != other and other.filename == filename
    end
  end

  def end_is_after_begin
    if self.duration and self.duration <= 0
      errors.add(:end, :before_begin) 
    end
  end

  def records_available
    unless source.nil? or source.records.empty?
      last_record = source.records.last

      if self.end <= last_record.end 
        if self.records.empty?
          errors.add(:begin, :no_record) 
          errors.add(:end, :no_record)
        end
      else
        errors.add(:end, :not_available_yet)
      end
    end
  end

  def source_can_store_it
    unless source.nil? or source.can_store?(self)
      errors.add_to_base(:source_cant_store)
    end
  end

  def sanitize_filename(filename)
    filename.downcase.gsub(/[^\w\.\-]/,'_')
  end

end
