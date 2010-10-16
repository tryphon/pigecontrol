Then /^(?:|I )should see a "([^\"]*)" link$/ do |text|
  response.should have_tag('a', text)
end
