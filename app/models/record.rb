class Record < ActiveRecord::Base

  belongs_to :source

  validates_presence_of :begin, :end, :filename
  validates_uniqueness_of :filename

  before_validation :compute_time_range

  named_scope :including, lambda { |from, to|
    { :conditions => Record.including_conditions(from, to) }
  }

  def self.including_conditions(from, to)
    conditions = 
      [ ["begin <= ? and end >= ?", from, from],
        ["begin >= ? and end <= ?", from, to],
        ["begin <= ? and end >= ?", to, to] ]

    expression_parts = []
    parameters = []

    conditions.each do |condition|
      expression_parts << "(#{condition.shift})"
      parameters = parameters + condition
    end

    [ expression_parts.join(" or ") ] + parameters
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

  def compute_time_range
    if not self.end and self.begin and self.duration
      self.end = self.begin + self.duration
    elsif not self.begin and self.end
      self.begin = self.end - self.duration
    end
  end

  def self.index(directory)
    Dir.chdir(directory) do
      Dir.glob(["**/*.wav", "**/*.ogg"], File::FNM_CASEFOLD).collect do |filename|
        Record.find_or_create_by_filename :filename => filename, :begin => Time.utc(*filename.scan(/\d+/))
      end
    end
  end

end
