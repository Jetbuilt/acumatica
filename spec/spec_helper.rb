# frozen_string_literal: true

require 'byebug'
require 'dotenv/load'
require 'vcr'

require 'acumatica'

require 'support/client'
require 'support/acumatica_resource'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.filter_sensitive_data('PLACEHOLDER_URL')      { ENV.fetch('ACUMATICA_URL') }
  c.filter_sensitive_data('PLACEHOLDER_USER')     { ENV.fetch('ACUMATICA_USER') }
  c.filter_sensitive_data('PLACEHOLDER_PASSWORD') { ENV.fetch('ACUMATICA_PASSWORD') }
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = "spec/reports/examples.txt"
  config.disable_monkey_patching!
  config.warnings = true

  config.default_formatter = "doc" if config.files_to_run.one?

  config.profile_examples = 10

  config.order = :random

  Kernel.srand config.seed
end
