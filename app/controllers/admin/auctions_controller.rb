class Admin::AuctionsController < Admin::BaseController
  respond_to :html

  def create
    create!(notice: t('activerecord.successful.messages.auction_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.auction_saved'))
  end

  private

  def build_resource_params
    [params.fetch(:auction, {}).permit(:product_id, :image_id, :start_price, :min_price, :duration, :bid_time_step, :bid_price_step)]
  end
end