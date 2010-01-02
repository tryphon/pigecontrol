class ChunksController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  def show
    show! do |format|
      format.wav { send_file @chunk.file, :type => :wav }
    end
  end

  protected

  def source
    association_chain.first
  end

  def label_selection
    user_session.label_selection
  end

  def build_resource
    if action_name == 'new' and label_selection.same_source?(source)
      @chunk = label_selection.chunk
    end

    super
  end

end
