class Bot
  def self.make_bid(auction)
    prev_bid = auction.bids.last
    if !prev_bid || !prev_bid.user.bot?
      Bid.create(auction: auction, user: User.random_bot)
    end
  end
end