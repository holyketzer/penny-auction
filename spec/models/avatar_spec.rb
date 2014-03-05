require 'spec_helper'

describe Avatar do
  describe "validations" do   
    #it { should validate_presence_of :source }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end
end
