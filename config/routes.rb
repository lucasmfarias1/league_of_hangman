Rails.application.routes.draw do
  get '/', to: 'guesses#show', as: :guesses
  post '/', to: 'guesses#win'
  get '/reset', to: 'guesses#reset', as: :reset
end
