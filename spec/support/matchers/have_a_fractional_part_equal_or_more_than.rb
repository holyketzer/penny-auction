
require 'rspec/expectations'

RSpec::Matchers.define :validate_min_fractionality_of do |attribute, value|
  match do |model|
    model.send("#{attribute}=", 10 + 0.9*value)
    !model.valid? && model.errors.has_key?(attribute) && model.errors[attribute].any? { |msg| msg.include?(value.to_s) }
  end

  failure_message_for_should do |model|
    "#{model.class} should not support #{attribute} fractional part less that #{value}"
  end
end