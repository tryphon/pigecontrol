def tune_file(duration = 300, format = "wav")
  File.expand_path("tmp/tune-#{duration}.#{format}").tap do |file|
    unless File.exists?(file)
      system "sox -n -r 44100 #{file} synth #{duration} sine 1000" or 
        raise "Can't create #{target}"
    end
  end
end
