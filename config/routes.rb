Rails.application.routes.draw do
  post 'sleep/clock_in', to: 'sleep#clock_in'
  post 'sleep/clock_out', to: 'sleep#clock_out'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
