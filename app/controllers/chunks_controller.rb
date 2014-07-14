class ChunksController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  respond_to :wav, :ogg, :mp3, :only => :show

  def show
    show! do |format|
      format.wav { send_file @chunk.file, :type => :wav }
      format.ogg { send_file @chunk.file, :type => :ogg }
      format.mp3 { send_file @chunk.file, :type => :mp3 }
    end
  end

  def create
    create!

    if @chunk.valid? and label_selection.same_time_range?(@chunk)
      label_selection.clear
    end
  end

  protected

  def collection
    @chunks ||= end_of_association_chain.find(:all, :order => "created_at DESC")
  end

  def source
    association_chain.first
  end

  def label_selection
    user_session.label_selection
  end

  def build_resource
    if action_name == 'new'
      if label_selection.same_source?(source)
        @chunk = label_selection.chunk
      end

      @chunk ||= source.default_chunk
    end

    super
  end

end
