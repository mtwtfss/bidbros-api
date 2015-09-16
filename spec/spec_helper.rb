ENV['RACK_ENV'] = 'test'

require 'rspec'
require 'rack/test'
require 'database_cleaner'
load 'app.rb'

RSpec.configure do |config|
  TYPE_DIR_MAPPINGS = {
    unit: %r{spec/lib/},
    integration: %r{spec/integration/}
  }

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  TYPE_DIR_MAPPINGS.each do |type, dir|
    config.define_derived_metadata(file_path: dir) do |metadata|
      metadata[:type] = type
    end
  end

  config.include RackApp, type: :integration
  config.include Rack::Test::Methods, type: :integration
  config.backtrace_exclusion_patterns << %r{/gems/}
end
