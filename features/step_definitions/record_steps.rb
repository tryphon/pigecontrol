Given /^records exist from "([^"]*)" to "([^"]*)"$/ do |records_begin, records_end|
  tune_records Time.parse(records_begin), Time.parse(records_end)
end
