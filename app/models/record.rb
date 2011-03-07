class Record < ActiveRecord::Base

  belongs_to :source

  validates_presence_of :begin, :end, :filename
  validates_uniqueness_of :filename

  validate :end_is_after_begin

  before_validation :compute_time_range

  named_scope :including, lambda { |from, to|
    { :conditions => Record.including_conditions(from, to) }
  }

  def before_validation
    self.source ||= Source.default
  end

  def self.including_conditions(from, to)
    conditions = 
      [ ["begin <= ? and end > ? ", from, from],
        ["begin >= ? and end <= ? ", from, to],
        ["begin < ? and end >= ? ", to, to] ]

    expression_parts = []
    parameters = []

    conditions.each do |condition|
      expression_parts << "(#{condition.shift})"
      parameters = parameters + condition
    end

    [ expression_parts.join(" or ") ] + parameters
  end

  def self.uniq(records)
    records = records.dup
    high_quality_records = {}

    records.each do |record|
      existing_record = high_quality_records[record.begin]
      if existing_record.nil? or record.quality > existing_record.quality
        high_quality_records[record.begin] = record
      end
    end

    records & high_quality_records.values
  end

  def time_range
    Range.new(self.begin, self.end)
  end

  def quality
    file_extension = File.extname(filename).downcase
    case file_extension
    when ".wav": 1
    when ".ogg": 0.8
    end
  end

  def file_duration
    return nil if self.filename.blank?

    TagLib::File.open(self.filename) do |file|
      file.length
    end
  rescue Exception => e
    logger.error "Can't read file duration for #{self.filename}"
    nil
  end

  def duration
    if self.begin and self.end
      self.end - self.begin
    else
      @duration ||= self.file_duration
    end
  end
  attr_writer :duration

  def filename_time_parts
    filename.scan(/\d+/)
  end

  def compute_time_range
    if self.begin.nil? and self.end.nil? and filename.present?
      self.begin = Time.utc(*filename_time_parts) unless filename_time_parts.empty?
    end

    if not self.end and self.begin and self.duration
      self.end = self.begin + self.duration
    elsif not self.begin and self.end
      self.begin = self.end - self.duration
    end
  end

  def self.index(filename)
    if File.directory?(filename)
      Record.index_directory filename
    else
      Record.index_file filename
    end
  end

  def self.index_file(filename)
    logger.debug "Index record #{filename}"
    Record.find_or_create_by_filename :filename => File.expand_path(filename) # FIXME , :begin => Time.utc(*filename.scan(/\d+/))
  end

  def self.index_directory(directory)
    Dir.chdir(directory) do
      Dir.glob("**/*.{wav,ogg}", File::FNM_CASEFOLD).collect do |filename|
        Record.index_file filename
      end
    end
  end

  private

  def end_is_after_begin
    if self.duration and self.duration <= 0
      errors.add(:end, "should be after #{self.begin}") 
    end
  end

end
