RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  FactoryGirl.find_definitions
end

FactoryGirl.define do
  to_create(&:save)
end
