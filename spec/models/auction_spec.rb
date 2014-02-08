require 'spec_helper'

describe Auction do
  describe 'validations' do   
    it { should validate_presence_of :product }
    it { should validate_presence_of :image }
    it { should validate_presence_of :duration }
    it { should validate_presence_of :min_price }
    it { should validate_presence_of :start_price }
    it { should validate_presence_of :start_time }
    it { should validate_presence_of :bid_time_step }
    it { should validate_presence_of :bid_price_step }    

    it { should validate_numericality_of(:duration).only_integer }
    it { should validate_numericality_of(:bid_time_step).only_integer }   

    it { should validate_numericality_of(:min_price).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:min_price, 0.01) }

    it { should validate_numericality_of(:start_price).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:start_price, 0.01) }

    it { should validate_numericality_of(:bid_price_step).is_greater_than_or_equal_to(0.01) }
    it { should validate_min_fractionality_of(:bid_price_step, 0.01) }

    it 'should have initial price' do 
      auction = create(:auction)
      expect(auction.price).to be auction.start_price
    end
  end

  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:image) }
    it { should have_many(:bids) }
  end

  describe 'auction bidding' do
    let(:user) { create(:user) }    
    
    context 'active' do
      let(:auction) { create(:auction, :active) }

      it 'should make bid' do
        last_duration = auction.duration
        last_price = auction.price

        bid = auction.make_bid(user)
        expect(bid.auction).to be auction
        expect(bid.user).to be user
        expect(auction.bids.last).to eq bid

        expect(auction.duration).to be(last_duration + auction.bid_time_step)
        expect(auction.price).to eq(last_price + auction.bid_price_step)
      end

      context 'not started' do
        let(:auction) { create(:auction, :not_started) }

        it 'should not make bid' do
          expect { bid = auction.make_bid(user) }.to raise_error
        end
      end

      context 'finished' do
        let(:auction) { create(:auction, :finished) }

        it 'should not make bid' do
          expect { bid = auction.make_bid(user) }.to raise_error
        end
      end
    end
  end
end