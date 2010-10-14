Given /^the following inputs:$/ do |inputs|
  Input.create!(inputs.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) input$/ do |pos|
  visit inputs_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following inputs:$/ do |expected_inputs_table|
  expected_inputs_table.diff!(tableish('table tr', 'td,th'))
end
