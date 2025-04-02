# frozen_string_literal: true

ConfigurableEngine::Engine.routes.draw do
  resource :configurable, path: '/', only: %i[show update]
end
