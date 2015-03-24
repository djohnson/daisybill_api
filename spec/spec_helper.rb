require 'rspec'
require 'rspec/its'
require 'rspec/collection_matchers'
require 'daisybill_api'
require 'vcr'
require 'ffaker'

Dir["#{DaisybillApi::ROOT}/spec/support/**/*.rb"].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = "#{DaisybillApi::ROOT}/spec/fixtures/vcr"
  config.hook_into :webmock
  config.default_cassette_options = { :record => :new_episodes }
  config.configure_rspec_metadata!
end

RSpec.configure do |config|
  config.before { DaisybillApi.reset_configuration }
end

def doubled_client(status, response)
  statuses = {
    success?: status == 200,
    bad_request?: status == 400,
    unauthorized?: status == 401,
    not_found?: status == 404,
    error?: status == 500,
    response: response
  }

  double(DaisybillApi::Data::Client, statuses)
end

def generate_attributes(attributes, for_class)
  attributes.each_with_object({}) { |name, result|
    if name.is_a? Hash
      name.each { |attr, attrs|
        type = for_class.attrs[attr.to_s]
        result[attr] = generate_attributes attrs, type
      }
    else
      type = for_class.attrs[name.to_s]
      result[name] = generate_attribute type
    end
  }
end

def generate_attribute(type)
  case type
    when :integer
      rand(201) - 100
    when :string
      FFaker::Lorem.word
    when :date
      Date.new(rand(15) + 2000, rand(12) + 1, rand(28) + 1)
    when :datetime
      DateTime.new
    else
      raise "Unknown Attribute Type: #{type.inspect}"
  end
end