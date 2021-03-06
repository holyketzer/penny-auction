require 'spec_helper'

describe Product do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of :description }
    it { should validate_presence_of :shop_price }
    it { should validate_numericality_of(:shop_price).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:shop_price, 0.01) }
    it { should validate_presence_of :category }
  end

  describe "associations" do
    it { should belong_to(:category) }
    it { should have_many(:images) }
  end
end
