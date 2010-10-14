Then /^the puppet configuration should contain "([^"]*)" with "([^"]*)"$/ do |key, value|
  PuppetConfiguration.load.attributes[key.to_sym].should == value
end
