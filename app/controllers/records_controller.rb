class RecordsController < InheritedResources::Base
  belongs_to :source

  actions :create
  respond_to :json

end
