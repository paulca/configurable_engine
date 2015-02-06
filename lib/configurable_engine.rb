require 'configurable_engine/engine'
require 'configurable_engine/configurables_controller'

module ConfigurableEngine
  mattr_accessor :custom_route, :generate_routes, :use_cache

  def self.configure
    yield self
  end

  def self.reset_config
    self.use_cache       = false
    self.generate_routes = true
    self.custom_route    = -> { admin_configurable_path }
  end

  def self.protected_attributes?
    @active_record_protected_attributes ||= ::ActiveRecord::VERSION::MAJOR < 4 || !!defined?(ProtectedAttributes)
  end

  reset_config
end
