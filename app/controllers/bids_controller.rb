class BidsController < InheritedResources::Base
  include ApplicationHelper
  include ActionView::Helpers::DateHelper

  belongs_to :auction

  respond_to :html, :only => [:create]
  respond_to :js, :only => [:create]

  before_filter :authenticate_user!

  def create
    auction = Auction.find(params[:auction_id])
    @bid = auction.make_bid(current_user)

    respond_to do |format|
      if @bid
        format.html { redirect_to auction, notice: t('auctions.actions.bid_made') }
        format.js do 
          PrivatePub.publish_to '/auctions/update', auction_id: auction.id, time_left: status_desc(auction).to_s, notice: t('auctions.actions.bid_made')
          render nothing: true
        end
      else
        format.html { redirect_to auction, notice: t('auctions.actions.bid_fail') }
        format.js do 
          PrivatePub.publish_to '/auctions/update', auction_id: auction.id, time_left: status_desc(auction).to_s, notice: t('auctions.actions.bid_fail')
          render nothing: true
        end
      end
    end
  end
end