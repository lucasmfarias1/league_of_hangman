Rails.application.routes.draw do
  get '/', to: 'guesses#show', as: :guesses
  post '/', to: 'guesses#create'
end
