require 'spec_helper'

describe Bid do
  let(:auction) { create(:auction) }
  let(:bid) { build(:bid, auction: auction) }
  before { WebMock.allow_net_connect! }

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

      # reloading is needed to auction.bids filling
      auction.reload
      new_bid = build(:bid, auction: auction, user: bid.user)

      expect(new_bid).to_not be_valid
    end
  end

  context 'when created' do
    before do
      allow(auction).to receive(:active?).and_return(true)
    end
    after { bid.save! }

    it "updates auction" do
      expect(auction).to receive(:increase_price_and_time)
    end

    it 'publish updates of auction' do
      expect(auction).to receive(:publish_updates)
    end
  end
end