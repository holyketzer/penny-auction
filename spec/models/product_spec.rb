require 'spec_helper'

describe Product do
	describe "name" do		
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe "description" do
  	it { should validate_presence_of :description }
  end

  describe "shop_price" do
  	it { should validate_presence_of :shop_price }
  	it { should validate_numericality_of(:shop_price).is_greater_than(0.01) }
  	it { should validate_min_fractionality_of(:shop_price, 0.01) }  	  	
  end
end
