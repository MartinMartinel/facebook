require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Facebook
  class Application < Rails::Application
    # Compiler options
    config.opal.method_missing      = true
    config.opal.optimized_operators = true
    config.opal.arity_check         = false
    config.opal.const_missing       = true
    config.opal.dynamic_require_severity = :ignore

    # Enable/disable /opal_specs route
    config.opal.enable_specs = true

    # The path to opal specs from Rails.root
    config.opal.spec_location = 'spec-opal'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.generators do|g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
    g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
