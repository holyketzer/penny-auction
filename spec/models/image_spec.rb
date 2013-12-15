require 'spec_helper'

describe Image do
  describe "validations" do   
    # TODO
  end

  describe "associations" do
    it { should belong_to(:imageable) }
  end
end
