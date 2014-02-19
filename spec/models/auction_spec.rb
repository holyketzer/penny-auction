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

      describe '#increase_price_and_time' do
        it 'insreases price' do
          expect { auction.increase_price_and_time }.to change(auction, :price).by(auction.bid_price_step)
        end

        it 'insreases duration' do
          expect { auction.increase_price_and_time }.to change(auction, :duration).by(auction.bid_time_step)
        end

        it 'saves changes' do          
          auction.increase_price_and_time
          price = auction.price
          duration = auction.duration
          
          auction.reload
          expect(auction.price).to eq price
          expect(auction.duration).to eq duration
        end
      end
    end    
  end
end