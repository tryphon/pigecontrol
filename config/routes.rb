ActionController::Routing::Routes.draw do |map|
  map.resources :sources do |source|
    source.resources :chunks
  end

  map.root :controller => "chunks", :action => "index", :source_id => "1"
end
