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
             sign_in: "api/v1/login",
             sign_out: "api/v1/logout"
           },
           controllers: {
             sessions: "users/sessions"
           }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
