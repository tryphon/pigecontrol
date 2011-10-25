ActionController::Routing::Routes.draw do |map|
  map.resources :sources do |source|
    source.resources :chunks
    source.resources :labels, :member => { :select => :get }
    source.resources :records
  end

  map.connect '/sources/:source_id/records/*path' , :controller => 'records' , :action => 'destroy', :conditions => { :method => :delete }

  map.resource :label_selection, :controller => :label_selection

  map.root :controller => "welcome"
end
