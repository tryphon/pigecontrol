def test_file(format = :ogg)
   File.expand_path "#{File.dirname __FILE__}/../fixtures/test.#{format}"
end
