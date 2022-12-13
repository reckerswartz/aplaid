Rails.application.routes.draw do
  defaults format: :json do
    resources :institutions, only: [:index, :show]
    resources :products, only: [:index, :show, :create] do
      member do
        get :accounts
      end
    end
  end
end
