Rails.application.routes.draw do
  namespace :api, constraints: { format: :json } do  
    resource :procedure do
      get :search
      post :load
    end
  end

  root 'home#index'
end
