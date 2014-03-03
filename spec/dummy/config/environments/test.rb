if Rails.env.test? && !defined?(ActiveSupport::Cache::NullStore)
  module ActiveSupport
    module Cache
      # A cache store implementation which doesn't actually store anything. Useful in
      # development and test environments where you don't want caching turned on but
      # need to go through the caching interface.
      #
      # This cache does implement the local cache strategy, so values will actually
      # be cached inside blocks that utilize this strategy. See
      # ActiveSupport::Cache::Strategy::LocalCache for more details.
      class NullStore < Store
        def initialize(options = nil)
          super(options)
          extend Strategy::LocalCache
        end

        def clear(options = nil)
        end

        def cleanup(options = nil)
        end

        def increment(name, amount = 1, options = nil)
        end

        def decrement(name, amount = 1, options = nil)
        end

        def delete_matched(matcher, options = nil)
        end

        protected
          def read_entry(key, options) # :nodoc:
          end

          def write_entry(key, entry, options) # :nodoc:
            true
          end

          def delete_entry(key, options) # :nodoc:
            false
          end
      end
    end
  end
end

Dummy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Disable caching during tests, 
  # can't use :null_store syntax because of Rails 3.1
  config.cache_store = ActiveSupport::Cache::NullStore.new

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  config.eager_load = false
end
