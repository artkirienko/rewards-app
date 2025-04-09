Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resource :account, only: [ :show ] do
        get :balance
        get :history
      end
      resources :rewards, only: [ :index, :show ] do
        post "redeem", to: "rewards#redeem"
      end
    end
  end
  devise_for :users,
           path: "",
           path_names: {
             sign_in: "login",
             sign_out: "logout"
           },
           controllers: {
             sessions: "users/sessions"
           },
           skip: [ :sessions ] # Skip all default session routes
  devise_scope :user do
    post "login", to: "users/sessions#create"
    delete "logout", to: "users/sessions#destroy"
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
