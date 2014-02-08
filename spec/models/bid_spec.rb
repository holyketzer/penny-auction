require 'spec_helper'

describe Bid do
  describe 'validations' do   
    it { should validate_presence_of :auction }
    it { should validate_presence_of :user }    
  end

  describe 'associations' do    
    it { should belong_to(:auction) }
    it { should belong_to(:user) }
  end  
end