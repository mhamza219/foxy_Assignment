class FileUploadsController < ApplicationController
  before_action :set_file_upload, only: %i[ show edit update destroy generate_token]
  before_action :authenticate_user!, except:[:download_file]

  # GET /file_uploads or /file_uploads.json
  def index
    @file_uploads = current_user.file_uploads
  end

  # GET /file_uploads/1 or /file_uploads/1.json
  def show
  end

  # GET /file_uploads/new
  def new
    # byebug
    @file_upload = current_user.file_uploads.new
  end

  # GET /file_uploads/1/edit
  def edit
  end

  # POST /file_uploads or /file_uploads.json
  def create
    # byebug
    @file_upload = current_user.file_uploads.new(file_upload_params)

    respond_to do |format|
      if @file_upload.save
        format.html { redirect_to @file_upload, notice: "File upload was successfully created." }
        format.json { render :show, status: :created, location: @file_upload }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @file_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /file_uploads/1 or /file_uploads/1.json
  def update
    respond_to do |format|
      if @file_upload.update(file_upload_params)
        format.html { redirect_to @file_upload, notice: "File upload was successfully updated." }
        format.json { render :show, status: :ok, location: @file_upload }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @file_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /file_uploads/1 or /file_uploads/1.json
  def destroy
    @file_upload.destroy!

    respond_to do |format|
      format.html { redirect_to file_uploads_path, status: :see_other, notice: "File upload was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # # Generatin share token
  def download_file
    # byebug
    @find_file_by_token = FileUpload.find_by_share_key(params[:share_key])
    if @find_file_by_token&.file&.attached?
      redirect_to rails_blob_url(@find_file_by_token.file, disposition: "attachment"), allow_other_host: true
      # render json: { status: 'success', message: 'File has been downloaded.'}
      # rails_blob_url(@find_file_by_token.file, disposition: "attachment")
    else
      redirect_to root_path, alert: "File not found."
    end
  end

  def generate_token
    # byebug
    # @file_upload = FileUpload.find(params[:id])
    
    if @file_upload.share_key.empty?
      @file_upload.update(share_key: SecureRandom.urlsafe_base64(16))
      redirect_to @file_upload, notice: "Token generated successfully."
    else
      redirect_to @file_upload, alert: "Token already exists."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_upload
      @file_upload = FileUpload.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def file_upload_params
      params.require(:file_upload).permit(:title, :description, :share_key, :user_id, :file)
    end
end
