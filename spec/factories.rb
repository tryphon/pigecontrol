Factory.define :source do |source|
  source.sequence(:name) { |n| "name-#{n}" }
end

Factory.define :chunk do |chunk|
  chunk.sequence(:title) { |n| "Test #{n}" }
  chunk.begin Time.now
  chunk.end { |c| c.begin + 5.minutes }
  chunk.source Source.default
end

Factory.define :record do |record|
  record.begin 15.minutes.ago
  record.duration 15.minutes
  record.sequence(:filename) { |n| "tmp/tests/file-2011-01-01-18-%02d.wav" % (n % 60) }

  record.after_build do |r|
    FileUtils.cp test_file(:wav), r.filename
  end
end

Factory.define :label do |label|
  label.name "name"
  label.timestamp Time.now
  label.source Source.default
end

