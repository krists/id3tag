RSpec.configure do |config|
  config.before(:each) do
    ID3Tag.reset_configuration
  end
end
