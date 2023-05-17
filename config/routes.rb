Rails.application.routes.draw do
  scope 'users' do
    get '', to: 'users#index'
    post '', to: 'users#create'
    post 'follow', to: 'users#follow'
    post 'unfollow', to: 'users#unfollow'
  end

  scope 'sleep' do
    post 'clock_in', to: 'sleep#clock_in'
    post 'clock_out', to: 'sleep#clock_out'
    get 'clocked_in_times', to: 'sleep#clocked_in_times'
    get 'following_user_records', to: 'sleep#following_user_records'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
