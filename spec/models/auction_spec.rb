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

  describe 'scopes' do
    describe 'finished_soon' do
      before do
        Timecop.freeze(Time.now)
      end

      after do
        Timecop.return
      end

      describe 'returns' do
        after { expect(Auction.finished_soon).to include(@auction) }

        it 'finished in 2 seconds auction' do
          @auction = create(:auction, finish_time: Time.now + 2.seconds)
        end

        it 'finished in 5 seconds auction' do
          @auction = create(:auction, finish_time: Time.now + 5.seconds)
        end
      end

      describe 'does not returns' do
        after { expect(Auction.finished_soon).to_not include(@auction) }

        it 'just now finished auction' do
          @auction = create(:auction, finish_time: Time.now)
        end

        it '1 second ago finished auction' do
          @auction = create(:auction, finish_time: Time.now - 1.second)
        end

        it 'auction which will be finished in more than 5 sec' do
          @auction = create(:auction, finish_time: Time.now + 6.second)
        end
      end
    end
  end
end