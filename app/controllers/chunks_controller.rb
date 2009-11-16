class ChunksController < InheritedResources::Base
  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json
end
