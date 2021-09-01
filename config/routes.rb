require 'sidekiq/web'
require 'sidekiq/cron/web'
Rails.application.routes.draw do
  get 'locations/show'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Sidekiq::Web => "/sidekiq"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
