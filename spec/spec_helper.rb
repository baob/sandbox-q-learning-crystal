SPEC_ROOT = __dir__ unless defined? SPEC_ROOT
APP_ROOT = File.expand_path('..', SPEC_ROOT) unless defined? APP_ROOT
LIB_ROOT = File.expand_path('lib', APP_ROOT) unless defined? LIB_ROOT

support_spec_files = File.expand_path('support/**/*.rb', __dir__)
Dir[support_spec_files].each(&method(:require))

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!

  # This setting enables warnings. It's recommended, but in some cases may
  # be too noisy due to issues in dependencies.
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end
