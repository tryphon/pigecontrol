class LabelsController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  protected

  def collection
    @labels ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 10, :order => 'timestamp desc')
  end

end
