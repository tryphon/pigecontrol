ActionController::Routing::Routes.draw do |map|
  map.resources :sources do |source|
    source.resources :chunks
  end
end
