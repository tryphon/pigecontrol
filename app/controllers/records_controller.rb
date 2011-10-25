class RecordsController < InheritedResources::Base
  belongs_to :source

  actions :create, :destroy
  respond_to :json

  protected

  def resource
    if params[:path].present?
      filename = Array(params[:path]).join('/')
      @record ||= Record.find_by_filename(filename).tap do |record|
        raise ActiveRecord::RecordNotFound unless record
      end
    else
      super
    end
  end

end
