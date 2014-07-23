class Account < ActiveRecord::Base
  attr_accessible :name, :url, :credential
end
