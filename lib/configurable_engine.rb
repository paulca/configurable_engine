require 'configurable_engine/engine'
require 'configurable_engine/configurables_controller'

module ConfigurableEngine
  mattr_accessor :generate_routes

  def self.configure
    yield self
  end

  def self.reset_config
    self.generate_routes = true
  end

  reset_config
end
