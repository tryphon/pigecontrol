class Source < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :chunks, :dependent => :destroy
  has_many :records

  def self.default
    find_or_create_by_name 'default'
  end

end
