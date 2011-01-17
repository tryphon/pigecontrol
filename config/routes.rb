ActionController::Routing::Routes.draw do |map|
  map.resources :sources do |source|
    source.resources :chunks
    source.resources :labels, :member => { :select => :get }
    source.resources :records
  end

  map.resource :label_selection, :controller => :label_selection

  map.root :controller => "welcome"
end
