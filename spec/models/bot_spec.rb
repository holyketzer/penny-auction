require 'spec_helper'

describe Bot do
  describe '.make_bid' do
    let!(:auction) { create(:auction) }
    let!(:user) { create(:user) }

    before { allow(auction).to receive(:active?).and_return(true) }

    context 'no bots' do
      it 'uses only bots' do
        expect { Bot.make_bid(auction) }.to_not change(auction.bids, :count)
      end
    end

    context 'bots available' do
      let!(:bot) { create(:bot) }
      let!(:next_bot) { create(:bot) }

      before do
        # random_bot stub first call returns bot, second call returns next_bot
        allow(User).to receive(:random_bot).and_return(bot, next_bot)
      end

      it 'add bid for given auction' do
        expect { Bot.make_bid(auction) }.to change(auction.bids, :count).by(1)
      end

      it 'does not create bid if previous one was made by another bot' do
        expect { Bot.make_bid(auction) }.to change(auction.bids, :count).by(1)
        expect { Bot.make_bid(auction) }.to_not change(auction.bids, :count)
      end

      it 'creates bid with random bot' do
        Bot.make_bid(auction)
        Bid.create!(auction: auction, user: user)
        Bot.make_bid(auction)

        expect(auction.bids.first.user).to_not eq(auction.bids.last.user)
      end
    end
  end
end