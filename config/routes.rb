ConfigurableEngine::Engine.routes.draw do
  resource :configurable, path: '/', only: [:show, :update]
end
