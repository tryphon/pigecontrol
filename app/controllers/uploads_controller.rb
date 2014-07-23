class UploadsController < InheritedResources::Base

  def cancel
    resource.cancel!
    redirect_to :back, :notice => t('flash.uploads.cancel.notice')
  end

  protected

  def collection
    @uploads ||= end_of_association_chain.order("updated_at DESC").includes(:account).paginate(:page => params[:page], :per_page => 20).decorate
  end

end
