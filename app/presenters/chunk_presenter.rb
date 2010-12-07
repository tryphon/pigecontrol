class ChunkPresenter

  def initialize(chunk)
    @chunk = chunk
  end

  def format
    ChunkFormatPresenter.find(@chunk.format)
  end
end
