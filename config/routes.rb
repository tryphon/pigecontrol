Pigecontrol::Application.routes.draw do
  resources :sources do |source|
    resources :chunks
    resources :labels do
      member { get :select }
    end
    resources :records
  end

  resource :label_selection, :controller => :label_selection
  resources :uploads do
    member { put :cancel }
  end

  root :to => "welcome#index"
end
