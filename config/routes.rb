Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'users#index'
    resources :users
    resources :sessions, only: [:new, :create, :destroy]
    resources :questions, except: [:show, :new, :index]

    get 'sign_up' => 'users#new'
    get 'log_out' => 'sessions#destroy'
    get 'log_in' => 'sessions#new'
  end
end
