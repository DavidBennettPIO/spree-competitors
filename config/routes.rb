Rails.application.routes.draw do
  
  namespace :admin do
    resources :competitors
    resources :competitor_prices, :only => [:index, :show]
  end
end
