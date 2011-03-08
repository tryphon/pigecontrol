class RecordsController < InheritedResources::Base
  belongs_to :source

  actions :create, :index, :show
  respond_to :json, :only => :create
  respond_to :rss, :only => :index

  def show
    show! do |format|
      format.wav { send_file @record.filename, :type => :wav }
      format.ogg { send_file @record.filename, :type => :ogg }
    end
  end

  private

  def collection
    @records ||= Record.uniq(end_of_association_chain.find(:all, :limit => 20, :order => "end desc"))
  end

end
