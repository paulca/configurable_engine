module ConfigurableEngine
  class ConfigurablesController < ApplicationController
    # this allows us to render url_helpers from parent app's layout
    helper Rails.application.routes.url_helpers
    # this ensures our local routes override any parent routes
    helper ConfigurableEngine::Engine.routes.url_helpers

    include ConfigurableEngine::ConfigurablesControllerMethods
  end
end
