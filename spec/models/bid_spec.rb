require 'spec_helper'

describe Bid do
  describe "validations" do   
    it { should validate_presence_of :auction }
    it { should validate_presence_of :user }

    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price) }
    it { should validate_min_fractionality_of(:price, 0.01) }
  end

  describe "associations" do    
    it { should belong_to(:auction) }
    it { should belong_to(:user) }
  end
end