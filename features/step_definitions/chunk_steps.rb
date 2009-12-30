Given /^the following chunks:$/ do |chunks|
  Chunk.create!(chunks.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) chunk$/ do |pos|
  visit chunks_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following chunks:$/ do |expected_chunks_table|
  expected_chunks_table.diff!(tableish('table tr', 'td,th'))
end
