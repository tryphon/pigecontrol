module TestFileSupport
  def test_file(format = :ogg)
    filename = File.expand_path "#{File.dirname __FILE__}/../fixtures/test.#{format}"
    
    unless File.exists?(filename)
      Sox.command do |sox| 
        sox.input test_file(:ogg)
        sox.output filename
      end
    end
    
    filename
  end
end

include TestFileSupport
