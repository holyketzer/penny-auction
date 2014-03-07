class Admin::AuctionsController < Admin::BaseController
  respond_to :html

  before_filter :load_product, only: [:new, :create, :edit, :update]

  def new
    if @products.empty?
      flash[:alert] = t('messages.create_product')
      redirect_to new_admin_product_path
    else
      super
    end
  end

  def create    
    create!(notice: t('activerecord.successful.messages.auction_saved'))
  end

  def update
    # If params doesn't contain :image_id it means that we should remove old image association
    # else user can save auction with product which doesn't have associated image
    resource.image = nil unless params.has_key?(:image_id)
    update!(notice: t('activerecord.successful.messages.auction_saved'))
  end

  def image_selector
    @product = Product.find(params[:product_id])
    render :layout => false
  end

  private

  def build_resource_params
    [params.fetch(:auction, {}).permit(:product_id, :image_id, :start_price, :start_time, :min_price, :duration, :bid_time_step, :bid_price_step)]
  end

  def load_product    
    @products = Product.order(:name)    
    product_id = params.fetch(:auction, {}).fetch(:product_id, nil)
    
    # Load current product
    # 1. If product was selected by user in form use product_id
    # 2. If auction already exists and contains product use it
    # 3. Else select first product by default
    @product = (product_id && Product.find(product_id)) || (params[:id] && resource.product) || @products.first
  end
end