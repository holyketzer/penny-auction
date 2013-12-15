require 'spec_helper'

describe Image do
  describe "validations" do   
    it { should validate_presence_of :description }
  end

  describe "associations" do
    it { should belong_to(:imageable) }
  end
end
