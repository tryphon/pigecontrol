Given /^the chunk is completed$/ do
  model("chunk").complete_with test_file(:wav)
end

Given /^all chunks are completed$/ do
  Chunk.all.each { |chunk| chunk.complete_with(test_file(chunk.format)) }
end

Then /^I should download a wav file$/ do
  response.content_type.should == "audio/x-wav"
  response.header["Content-Disposition"].should match(/attachment; filename=".*\.wav"/)
end

Then /^I should download a mp3 file$/ do
  response.content_type.should == "audio/mpeg"
  response.header["Content-Disposition"].should match(/attachment; filename=".*\.mp3"/)
end

Then /^I should download a ogg file$/ do
  response.content_type.should == "application/ogg"
  response.header["Content-Disposition"].should match(/attachment; filename=".*\.ogg"/)
end
