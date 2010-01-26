class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :chunks, :dependent => :destroy
  has_many :records, :dependent => :destroy, :order => "begin"
  has_many :labels, :dependent => :destroy

  def self.default
    find_or_create_by_name 'default'
  end

  def default_chunk
    unless records.empty?
      chunks.build.tap do |chunk|
        beginning_of_last_hour = records.last.end.change(:min => 0)
        chunk.begin = [beginning_of_last_hour, records.first.begin].max
        chunk.end = records.last.end
      end
    end
  end

end
