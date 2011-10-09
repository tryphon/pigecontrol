require 'tagfile'

module TagFile
  class File

    def self.open(filename, &block)
      file = TagFile::File.new(filename)

      begin
        return yield file
      ensure
        file.close
      end
    end

    def size
      ::File.size(@path)
    end

    # Workaround
    # squeeze taglib returns 0 for wav files
    def length_with_wav_support
      if @path =~ /\.wav/i
        bitrate = self.bitrate
        bitrate = 1378.125 if bitrate == 1378
        self.size / (bitrate / 8 * 1024)
      else
        length_without_wav_support
      end
    end
    alias_method_chain :length, :wav_support
    
  end
end
