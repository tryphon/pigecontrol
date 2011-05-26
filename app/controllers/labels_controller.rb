# -*- coding: utf-8 -*-
class LabelsController < InheritedResources::Base
  belongs_to :source

  actions :all, :except => [ :edit, :update ]
  respond_to :html, :xml, :json

  def create
    create! do |success, failure|
      success.html do
        redirect_to source_labels_path(label.source) 
      end
    end
  end

  def select
    user_session.label_selection << label
    if user_session.label_selection.completed?
      flash[:notice] = t("label_selection.flash.create_chunk")
      redirect_to new_source_chunk_path(label.source)
    else
      redirect_to :back
    end
  end

  def destroy
    if user_session.label_selection.include? label
      user_session.label_selection.clear
    end
    destroy!
  end

  protected

  def label
    resource
  end

  def collection
    @labels ||= end_of_association_chain.paginate(:page => params[:page], :per_page => 10, :order => 'timestamp desc')
  end

end
