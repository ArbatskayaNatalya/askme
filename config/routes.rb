Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root 'users#index'
    resources :users
    resources :questions

    get 'show' => 'users#show'
  end
end
