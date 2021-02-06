Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/weather/location/:id' => 'weather#location'
  get '/weather/summary' => 'weather#summary'
end
