require 'spec_helper'

describe Auction do
  describe "validations" do   
    it { should validate_presence_of :product_id }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :min_price }
    it { should validate_presence_of :start_price }
    it { should validate_presence_of :bid_time_step }
    it { should validate_presence_of :bid_price_step }

    it { should validate_numericality_of(:duration).only_integer }
    it { should validate_numericality_of(:bid_time_step).only_integer }
    
    it { should validate_numericality_of(:min_price).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:min_price, 0.01) }

    it { should validate_numericality_of(:start_price).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:start_price, 0.01) }

    it { should validate_numericality_of(:bid_price_step).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:bid_price_step, 0.01) }
  end

  describe "associations" do
    it { should belong_to(:product) }
    it { should belong_to(:image) }
  end
end