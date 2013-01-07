require 'time_ext'

Factory.define :source do |source|
  source.sequence(:name) { |n| "name-#{n}" }
end

Factory.define :chunk do |chunk|
  chunk.sequence(:title) { |n| "Test #{n}" }
  chunk.begin Time.now
  chunk.end { |c| c.begin + 5.minutes }
  chunk.source Source.default
  
  chunk.after_build do |chunk|
    # tune_records chunk.begin, chunk.end
  end
end

Factory.define :record, :class => Pige::Record, :default_strategy => :build do |record|
  record.begin 15.minutes.ago.floor(:min, 5.minutes)
  record.duration 5.minutes

  record.after_build do |record|
    record.filename = "#{Pige::Record::Index.record_directory}/#{Pige::Record::Index.new.basename_at(record.begin)}.wav"

    FileUtils.mkdir_p File.dirname(record.filename)
    FileUtils.cp tune_file(record.duration), record.filename
    FileUtils.touch record.filename, :mtime => Time.now - 1.minute
  end
end

Factory.define :label do |label|
  label.name "name"
  label.timestamp Time.now
  label.source Source.default
end

