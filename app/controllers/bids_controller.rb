class BidsController < InheritedResources::Base
  include ApplicationHelper
  include ActionView::Helpers::DateHelper
  belongs_to :auction

  respond_to :html, :only => [:create]
  respond_to :json, :only => [:create]

  before_filter :authenticate_user!

  def create
    auction = Auction.find(params[:auction_id])
    @bid = Bid.new(user: current_user, auction: auction)

    respond_to do |format|
      if @bid.save
        format.html do
          push_auction_update(auction)
          redirect_to auction, notice: t('auctions.actions.bid_made') 
        end
        format.json do 
          push_auction_update(auction)
          render_flash(success: t('auctions.actions.bid_made'))
        end
      else
        format.html { redirect_to auction, notice: t('auctions.actions.bid_fail') }
        format.json { render_flash(error: t('auctions.actions.bid_fail')) }
      end      
    end
  end

  private

  def push_auction_update(auction)    
    PrivatePub.publish_to '/auctions/update', auction_id: auction.id, time_left: status_desc(auction), price: auction.price
  end

  def render_flash(messages)
    messages.each_key { |type| flash.now[type] = messages[type] }    
    # if resource.errors.any?
    #   render json: { notice: render_to_string('shared/_validation_errors.html', layout: false) }
    # else
      render json: { notice: render_to_string('shared/_flash.html', layout: false) }
    # end
  end
end