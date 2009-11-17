class ChunksController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json
end
