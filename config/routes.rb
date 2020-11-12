Rails.application.routes.draw do
  devise_for :users

    namespace :api, defaults: {format: :json} do
      devise_scope :user do
        post "sign_up",  to: "registrations#create"
        post "sign_in",  to: "sessions#create"
        post "sign_out", to: "sessions#destroy"
      end

      resources :pokemons, only: [:index]
  end
end
