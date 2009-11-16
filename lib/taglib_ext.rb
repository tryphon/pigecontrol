module TagLib
  class File
    def self.open(filename, &block)
      file = TagLib::File.new(filename)

      begin
        return yield file
      ensure
        file.close
      end
    end
  end
end
