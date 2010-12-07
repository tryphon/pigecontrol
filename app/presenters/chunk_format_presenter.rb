class ChunkFormatPresenter

  attr_accessor :format, :name, :wikipedia_page

  def initialize(format, name, wikipedia_page)
    @format, @name, @wikipedia_page = format, name, wikipedia_page
  end

  @@instances = 
    [
     ChunkFormatPresenter.new(:wav, "Wave", "Wav"),
     ChunkFormatPresenter.new(:vorbis, "Ogg/Vorbis", "Vorbis"),
     ChunkFormatPresenter.new(:mp3, "MP3", "MP3")
    ]

  def wikipedia_url
    "http://#{I18n.locale}.wikipedia.org/wiki/#{wikipedia_page}"
  end

  def requires_birate?
    Chunk.requires_bitrate?(format)
  end

  def requires_quality?
    Chunk.requires_quality?(format)
  end

  def self.find(format)
    all.find { |p| p.format == format }
  end

  def self.all
    @@instances
  end

  def to_s
    name
  end
end
