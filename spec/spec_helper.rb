$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pronto/dialyzer'
require 'rspec'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.mock_with(:rspec) { |c| c.syntax = :expect }
end
