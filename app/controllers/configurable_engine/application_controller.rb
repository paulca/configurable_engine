module ConfigurableEngine
  class ApplicationController < ActionController::Base
    layout "configurable_engine/application"
    protect_from_forgery with: :exception
  end
end
