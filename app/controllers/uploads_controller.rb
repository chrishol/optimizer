class UploadsController < ApplicationController
  def new
  end

  def create
    uploaded_file = params[:file]

    gameweek = Gameweek.find(params[:gameweek_id])

    if uploaded_file&.tempfile.present?
      ProjectionSetImporter.new(gameweek).import_csv(uploaded_file.tempfile.to_path)
    end

    redirect_back(fallback_location: new_upload_path)
  end

  private

  def upload_class
    
  end
end
