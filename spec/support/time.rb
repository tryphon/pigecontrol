RSpec::Matchers.define :be_at do |expected|
  expected = Time.parse(expected) if expected.is_a? String
  match do |actual|
    expected.to_i == actual.to_i
  end
end
