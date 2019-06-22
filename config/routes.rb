Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/timesheets', to: 'timesheets#index'
  post "/timesheets", to: "timesheets#create"
  get '/timesheets/new', to: 'timesheets#new', as: "new_timesheet"

  root 'timesheets#index'
end
