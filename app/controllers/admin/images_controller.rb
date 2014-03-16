class Admin::ImagesController < Admin::BaseController
  respond_to :html

  before_filter :load_imageable

  def create
    @image = resource
    if @imageable.respond_to? :image
      @imageable.image = @image
    else
      @imageable.images << @image
    end

    create!(notice: t('activerecord.successful.messages.image_saved')) { [:admin, @imageable] }
  end

  def update
    update!(notice: t('activerecord.successful.messages.image_saved')) { [:admin, @imageable] }
  end

  def destroy
    destroy!(notice: t('activerecord.successful.messages.image_deleted')) { [:admin, @imageable] }
  end

  private
    def load_imageable
      resource, id = request.path.split('/')[2, 3]
      @imageable = resource.singularize.classify.constantize.find(id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def build_resource_params
      [params.fetch(:image, {}).permit(:imageable_id, :source)]
    end
end
