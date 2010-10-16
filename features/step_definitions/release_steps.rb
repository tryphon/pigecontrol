Given /^the current release is "([^\"]*)"$/ do |name|
  Release.find_or_create_by_status("installed").update_attribute(:name, name)
end

Given /^the latest release is "([^\"]*)"$/ do |name|
  Release.create! :name => name
end

Given /^the new release is downloaded$/ do 
  Release.latest.update_attribute :status, :downloaded
end

Given /^a new release is available$/ do 
  Release.create! :name => Release.current.name.succ
end
