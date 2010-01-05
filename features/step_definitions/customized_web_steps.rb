Then /^the "([^\"]*)" datetime should contain "([^\"]*)"$/ do |field, value|
  selected_datetime(:from => field).should == Time.parse(value)
end
