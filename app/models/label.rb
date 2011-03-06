class Label < ActiveRecord::Base

  belongs_to :source

  validates_presence_of :name, :timestamp

  def after_initialize
    self.timestamp = Time.now if timestamp.blank?
  end

  def date
    timestamp.to_date
  end

end
