Factory.define :source do |s|
  s.sequence(:name) { |n| "name-#{n}" }
end

Factory.define :chunk do |c|
  c.begin 15.minutes.ago
  c.end Time.now
  c.association :source
end
