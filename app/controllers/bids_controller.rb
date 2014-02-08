class BidsController < InheritedResources::Base
  belongs_to :auction

  respond_to :html, :only => [:create]

  before_filter :authenticate_user!

  def create
    auction = Auction.find(params[:auction_id])
    @bid = auction.make_bid(current_user)

    respond_to do |format|
      if @bid
        format.html { redirect_to auction, notice: t('auctions.actions.bid_made') }
      else
        format.html { redirect_to auction, notice: t('auctions.actions.bid_fail') }
      end
    end
  end
end