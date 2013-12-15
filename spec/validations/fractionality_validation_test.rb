require 'spec_helper'

require 'validations/models/topic'
require 'bigdecimal'

describe FractionalityValidator do 
  after do
    Topic.reset_callbacks(:validate)
  end

  NIL = [nil]
  BLANK = ["", " ", " \t \r \n"]
  BIGDECIMAL_STRINGS = %w(12345678901234567890.1234567890) # 30 significant digits
  FLOAT_STRINGS = %w(0.0 +0.0 -0.0 10.0 10.5 -10.5 -0.0001 -090.1 90.1e1 -90.1e5 -90.1e-5 90e-5)
  INTEGER_STRINGS = %w(0 +0 -0 10 +10 -10 0090 -090)
  FLOATS = [0.0, 10.0, 10.5, -10.5, -0.0001] + FLOAT_STRINGS
  INTEGERS = [0, 10, -10] + INTEGER_STRINGS
  BIGDECIMAL = BIGDECIMAL_STRINGS.collect! { |bd| BigDecimal.new(bd) }
  JUNK = ["not a number", "42 not a number", "0xdeadbeef", "0xinvalidhex", "0Xdeadbeef", "00-1", "--3", "+-3", "+3-1", "-+019.0", "12.12.13.12", "123\nnot a number"]
  INFINITY = [1.0/0.0]

  it "should validate fractionality" do
    Topic.validates_fractionality_of :approved
    invalid!(NIL + BLANK + JUNK + INTEGERS)
    valid!(FLOATS + BIGDECIMAL + INFINITY) 
  end

  it "should validate fractionality with nil allowed" do
    Topic.validates_fractionality_of :approved, allow_nil: true
    invalid!(JUNK + BLANK + INTEGERS)
    valid!(NIL + FLOATS + BIGDECIMAL + INFINITY) 
  end

  it "should validate fractionality with greater than" do
    Topic.validates_fractionality_of :approved, multiplier: 0.01
    invalid!([-10.009, 10.015, -9.011, 9.005], 'should be multiplication of 0.01')
    valid!([11.02, 1.0, 10.01, 789.95, 10.15, 10.0])
  end  

  private

  def invalid!(values, error = nil)
    with_each_topic_approved_value(values) do |topic, value|      
      expect(topic).to be_invalid, "#{value.inspect} not rejected as a number without valid fractional part"
      expect(topic.errors[:approved]).to be_any, "FAILED for #{value.inspect}"      
      expect(error).to eq(topic.errors[:approved].first) if error
    end
  end

  def valid!(values)
    with_each_topic_approved_value(values) do |topic, value|
      expect(topic).to be_valid, "#{value.inspect} not accepted as a number with valid fractional part"
    end
  end

  def with_each_topic_approved_value(values)
    topic = Topic.new(title: "fractionality test", content: "whatever")
    values.each do |value|
      topic.approved = value
      yield topic, value
    end
  end
end