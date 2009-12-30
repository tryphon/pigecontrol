Factory.define :source do |source|
  source.sequence(:name) { |n| "name-#{n}" }
end

Factory.define :chunk do |chunk|
  chunk.begin 15.minutes.ago
  chunk.end Time.now
  chunk.source Source.default
end

Factory.define :record do |record|
  record.begin 15.minutes.ago
  record.end Time.now
  record.filename { |n| "file#{n}" }
end
