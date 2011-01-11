Then /^the "([^\"]*)" datetime should contain "([^\"]*)"$/ do |field, value|
  selected_datetime(:from => field).should == Time.parse(value)
end

When /^I reload the current page$/ do
  visit current_url
end
