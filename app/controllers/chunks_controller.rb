class ChunksController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  def show
    show! do |format|
      format.wav { send_file @chunk.file, :type => :wav }
    end
  end
end
