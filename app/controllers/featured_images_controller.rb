class FeaturedImagesController < ApplicationController
  # TODO: allow only moderators to edit
  before_action :set_featured_image, only: %i[ show edit update destroy ]

  # GET /featured_images or /featured_images.json
  def index
    @featured_images = FeaturedImage.all
  end

  # GET /featured_images/1 or /featured_images/1.json
  def show

  end

  # GET /featured_images/new
  def new
    community = Community.find(RequestContext.community_id)

    if community.featured_image.present?
        redirect_to edit_featured_image_path(community.featured_image), notice: "An image is already set. Redirected to update instead."
    end

    @featured_image = FeaturedImage.new
  end

  # GET /featured_images/1/edit
  def edit
  end

  # POST /featured_images or /featured_images.json
  def create

    @featured_image = FeaturedImage.create(featured_image_params)
    # TODO: sanitize && validate input
    # TODO: resize image!

    respond_to do |format|
      if @featured_image.save
        format.html { redirect_to root_path, notice: "Featured image was successfully created." }
        format.json { render :show, status: :created, location: @featured_image }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @featured_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /featured_images/1 or /featured_images/1.json
  def update
    respond_to do |format|
      if @featured_image.update(featured_image_params)
        format.html { redirect_to featured_image_url(@featured_image), notice: "Featured image was successfully updated." }
        format.json { render :show, status: :ok, location: @featured_image }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @featured_image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_images/1 or /featured_images/1.json
  def destroy
    @featured_image.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Featured image was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_featured_image
    @featured_image = FeaturedImage.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def featured_image_params
    params.require(:featured_image).permit(:header_text, :image)
    # params.fetch(:featured_image, {})
  end
end
