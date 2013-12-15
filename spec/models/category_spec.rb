require 'spec_helper'

describe Category do
  describe "validations" do   
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of :description }
  end

  describe "associations" do
    it { should have_many(:products) }
    it { should have_one(:image) }
  end
end
