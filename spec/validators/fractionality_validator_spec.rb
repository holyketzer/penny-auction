require 'spec_helper'

require 'validators/models/topic'
require 'bigdecimal'

describe FractionalityValidator do 
  after do
    Topic.reset_callbacks(:validate)
  end

  NULL = [nil]
  BLANK = ["", " ", " \t \r \n"]
  BIGDECIMAL_STRINGS = %w(12345678901234567890.1234567890) # 30 significant digits
  FLOAT_STRINGS = %w(0.0 +0.0 -0.0 10.0 10.5 -10.5 -0.0001 -090.1 90.1e1 -90.1e5 -90.1e-5 90e-5)
  INTEGER_STRINGS = %w(0 +0 -0 10 +10 -10 0090 -090)
  FLOATS = [0.0, 10.0, 10.5, -10.5, -0.0001] + FLOAT_STRINGS
  INTEGERS = [0, 10, -10] + INTEGER_STRINGS
  BIGDECIMAL = BIGDECIMAL_STRINGS.collect! { |bd| BigDecimal.new(bd) }
  JUNK = ["not a number", "42 not a number", "0xdeadbeef", "0xinvalidhex", "0Xdeadbeef", "00-1", "--3", "+-3", "+3-1", "-+019.0", "12.12.13.12", "123\nnot a number"]
  INFINITY = [1.0/0.0]

  describe 'should validate fractionality' do
    context 'without options' do
      before do
        Topic.validates_fractionality_of :approved
      end

      it "should be invalid with wrong values" do      
        expect_to_be_invalid(NULL + BLANK + JUNK + INTEGERS)
      end

      it "should be valid with right values" do
        expect_to_be_valid(FLOATS + BIGDECIMAL + INFINITY) 
      end
    end

    context 'with allow_nil option' do
      before do
        Topic.validates_fractionality_of :approved, allow_nil: true
      end      

      it "should be invalid with wrong values" do
        expect_to_be_invalid(JUNK + BLANK + INTEGERS)
      end

      it "should be valid with right values" do
        expect_to_be_valid(NULL + FLOATS + BIGDECIMAL + INFINITY) 
      end
    end

    context 'with multiplier option' do
      before do 
        Topic.validates_fractionality_of :approved, multiplier: 0.01
      end

      it "should be invalid with wrong values" do
        expect_to_be_invalid([-10.009, 10.015, -9.011, 9.005], 'should be multiplication of 0.01')
      end

      it "should be valid with right values" do
        expect_to_be_valid([11.02, 1.0, 10.01, 789.95, 10.15, 10.0])
      end
    end
  end    

  private

  def expect_to_be_invalid(values, error = nil)
    with_each_topic_approved_value(values) do |topic, value|      
      expect(topic).to be_invalid , "#{value.inspect} not rejected as a number without valid fractional part"
      expect(topic.errors[:approved]).to be, "failed for #{value.inspect}"      
      expect(error).to eq(topic.errors[:approved].first) if error
    end
  end

  def expect_to_be_valid(values)
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