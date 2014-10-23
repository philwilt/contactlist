Rails.application.routes.draw do
  resources :contacts, only: [:new, :create]
  root 'contacts#new'
end
