Rails.application.routes.draw do
  post 'sleep/clock_in', to: 'sleep#clock_in'
  post 'sleep/clock_out', to: 'sleep#clock_out'
  get 'sleep/clocked_in_times', to: 'sleep#clocked_in_times'
  get 'users', to: 'users#index'
  post 'users', to: 'users#create'
  post 'users/follow', to: 'users#follow'
  post 'users/unfollow', to: 'users#unfollow'
  get 'sleep/following_user_records', to: 'sleep#following_user_records'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
