class Admin::CategoriesController < Admin::BaseController
  respond_to :html

  def show
    @imageable = resource
    @image = Image.new
  end

  def create
    create!(notice: t('activerecord.successful.messages.category_saved'))
  end

  def update
    update!(notice: t('activerecord.successful.messages.category_saved'))
  end

  private

  def build_resource_params
    [params.fetch(:category, {}).permit(:name, :description, :parent_id, :image_id)]
  end
end
