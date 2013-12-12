require 'spec_helper'

describe Category do
	describe "name" do		
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
  end

  describe "description" do
  	it { should validate_presence_of :description }
  end

  context "ancestry" do
  	# TODO: implement ancestry testing
  	# it { should belong_to(:category) }
  end
end
