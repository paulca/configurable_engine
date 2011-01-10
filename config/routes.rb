Rails.application.routes.draw do
  namespace :admin do
    resource :configurable
  end
end