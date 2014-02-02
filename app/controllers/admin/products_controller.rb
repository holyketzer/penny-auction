class Admin::ProductsController < Admin::BaseController
  respond_to :html  

  def show
    @imageable = resource
    @image = Image.new
  end

  def create
    create!(notice: t('activerecord.successful.messages.product_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.product_saved'))
  end

  private

  def build_resource_params
    [params.fetch(:product, {}).permit(:name, :description, :shop_price, :category_id)]
  end
end