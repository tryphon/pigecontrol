Given /^the chunk is completed$/ do
  model("chunk").complete_with test_file(:wav)
end

Then /^I should download a wav file$/ do
  response.content_type.should == "audio/x-wav"
  response.header["Content-Disposition"].should match(/attachment; filename=".*\.wav"/)
end
