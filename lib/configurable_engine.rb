require 'configurable_engine/engine'
require 'configurable_engine/configurables_controller'

module ConfigurableEngine
  mattr_accessor :custom_route, :generate_routes

  def self.configure
    yield self
  end

  def self.reset_config
    self.generate_routes = true
    self.custom_route    = -> { admin_configurable_path }
  end

  reset_config
end
