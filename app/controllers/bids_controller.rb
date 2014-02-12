class BidsController < InheritedResources::Base
  include ApplicationHelper
  include ActionView::Helpers::DateHelper
  include BootstrapFlashHelper

  belongs_to :auction

  respond_to :html, :only => [:create]
  respond_to :json, :only => [:create]

  before_filter :authenticate_user!

  def create
    auction = Auction.find(params[:auction_id])
    @bid = auction.make_bid(current_user)

    respond_to do |format|
      if @bid
        format.html { redirect_to auction, notice: t('auctions.actions.bid_made') }
        format.json { push_auction_update(auction, success: t('auctions.actions.bid_made')) }
      else
        format.html { redirect_to auction, notice: t('auctions.actions.bid_fail') }
        format.json { push_auction_update(auction, error: t('auctions.actions.bid_fail')) }
      end
    end
  end

  private

  def push_auction_update(auction, messages)
    messages.each_key { |type| flash[type] = messages[type] }
    PrivatePub.publish_to '/auctions/update', auction_id: auction.id, time_left: status_desc(auction).to_s
    render json: { notice: render_to_string('shared/_flash.html', layout: false) }
  end
end