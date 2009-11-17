class Chunk < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :begin, :end

  def records
    if self.begin and self.end
      self.source.records.including(self.begin, self.end)
    else
      []
    end
  end
end
