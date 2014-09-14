class Label < ActiveRecord::Base

  belongs_to :source
  validates_presence_of :name, :timestamp, :source_id

  attr_accessible :name, :timestamp

  after_initialize :set_default_timestamp

  def set_default_timestamp
    self.timestamp = Time.zone.now if timestamp.blank?
  end

  def date
    timestamp.to_date
  end

end
