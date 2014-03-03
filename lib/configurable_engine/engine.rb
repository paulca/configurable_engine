module ConfigurableEngine
  class Engine < Rails::Engine
    config.use_cache = false
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end