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
        format.html { redirect_to auction, notice: t('activerecord.successful.messages.bid_made') }
        format.json { render_flash(success: t('activerecord.successful.messages.bid_made')) }
      else
        messages = Hash[@bid.errors.map { |attr, msg| [:error, msg] }]
        format.html { redirect_to auction, flash: messages }
        format.json { render_flash(messages) }
      end
    end
  end

  private

  def render_flash(messages)
    messages.each_key { |type| flash.now[type] = messages[type] }
    render json: { notice: render_to_string('shared/_flash.html', layout: false) }
  end
end