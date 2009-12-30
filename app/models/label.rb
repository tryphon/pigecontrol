class Label < ActiveRecord::Base
  belongs_to :source

  validates_presence_of :name, :timestamp
end
