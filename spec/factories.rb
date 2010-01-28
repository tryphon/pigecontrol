Factory.define :source do |source|
  source.sequence(:name) { |n| "name-#{n}" }
end

Factory.define :chunk do |chunk|
  chunk.begin Time.now
  chunk.end { |c| c.begin + 5.minutes }
  chunk.source Source.default
end

Factory.define :record do |record|
  record.begin 15.minutes.ago
  record.duration 15.minutes
  record.filename { |n| "file#{n}.wav" }
end

Factory.define :label do |label|
  label.name "name"
  label.timestamp Time.now
  label.source Source.default
end

