class Admin::ImagesController < Admin::BaseController
  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_filter :load_imageable

  # GET /images
  # GET /images.json
  def index
    @images = Image.all
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new    
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  # POST /images.json
  def create
    if @imageable.respond_to? :image
      @image = Image.new(image_params)
      @imageable.image = @image
    else
      @image = @imageable.images.new(image_params)
    end

    respond_to do |format|
      if @image.save
        format.html { redirect_to [:admin, @imageable], notice: t('activerecord.successful.messages.image_saved') }
      else
        format.html { redirect_to [:admin, @imageable], notice: 'Image validation is failed' }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if @image.update(image_params)
        format.html { redirect_to [:admin, @imageable], notice: t('activerecord.successful.messages.image_saved') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image.destroy
    respond_to do |format|
      format.html { redirect_to [:admin, @imageable], notice: t('activerecord.successful.messages.image_deleted') }
      format.json { head :no_content }
    end
  end

  private
    def load_imageable
      resource, id = request.path.split('/')[2, 3]
      @imageable = resource.singularize.classify.constantize.find(id)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_image
      @image = Image.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:imageable_id, :source)
    end
end
