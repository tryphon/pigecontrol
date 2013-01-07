class RecordCleaner

  def self.setup
    Pige::Record::Index.record_directory = "tmp/tests"
    FileUtils.mkdir_p Pige::Record::Index.record_directory
  end

  def self.clean
    FileUtils.rm_rf Pige::Record::Index.record_directory
  end

end

class RecordFactory < Struct.new(:begin, :end)

  def record_duration
    5.minutes
  end

  def create
    records_begin = self.begin.floor(:min, record_duration)
    records_begin.to_i.step(self.end.to_i, record_duration).each do |record_begin|
      Factory(:record, :begin => Time.at(record_begin), :duration => record_duration)
    end
  end

end

def tune_records(records_begin, records_end)
  RecordFactory.new(records_begin, records_end).create
end
