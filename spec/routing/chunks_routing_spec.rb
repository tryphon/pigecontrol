require 'spec_helper'

describe ChunksController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/sources/1/chunks" }.should route_to(:controller => "chunks", :action => "index", :source_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/sources/1/chunks/new" }.should route_to(:controller => "chunks", :action => "new", :source_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/sources/1/chunks/1" }.should route_to(:controller => "chunks", :action => "show", :source_id => "1", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/sources/1/chunks/1/edit" }.should route_to(:controller => "chunks", :action => "edit", :source_id => "1", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/sources/1/chunks" }.should route_to(:controller => "chunks", :action => "create", :source_id => "1") 
    end

    it "recognizes and generates #update" do
      { :put => "/sources/1/chunks/1" }.should route_to(:controller => "chunks", :action => "update", :source_id => "1", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sources/1/chunks/1" }.should route_to(:controller => "chunks", :action => "destroy", :source_id => "1", :id => "1") 
    end
  end
end
