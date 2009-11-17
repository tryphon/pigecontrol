class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :chunks
  has_many :records

end
