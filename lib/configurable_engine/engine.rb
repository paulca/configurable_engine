module ConfigurableEngine
  class Engine < ::Rails::Engine
    engine_name "configurable"
    isolate_namespace ConfigurableEngine
    config.use_cache = false
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
