class Label < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :name, :timestamp

  def date
    timestamp.to_date
  end
end
