require 'spec_helper'

describe Bid do
  let(:auction) { create(:auction) }  
  let(:bid) { build(:bid, auction: auction) }

  describe 'associations' do    
    it { should belong_to(:auction) }
    it { should belong_to(:user) }
  end

  describe 'validations' do   
    it { should validate_presence_of :auction }
    it { should validate_presence_of :user }

    it 'valid only for active auction' do
      allow(auction).to receive(:active?).and_return(true)
      expect(bid).to be_valid
    end

    it 'not valid if auction is not active' do
      allow(auction).to receive(:active?).and_return(false)
      expect(bid).to_not be_valid
    end

    it 'not valid for same user twice' do
      allow(auction).to receive(:active?).and_return(true)
      bid.save!      

      # reloading is needed to auction.bids filling, probably I don't understand something
      auction.reload       
      new_bid = build(:bid, auction: auction, user: bid.user)
      
      expect(new_bid).to_not be_valid
    end
  end

  context 'when created' do
    it "updates auction" do
      allow(auction).to receive(:active?).and_return(true)

      expect(auction).to receive(:increase_price_and_time)
      bid.save!
    end
  end
end