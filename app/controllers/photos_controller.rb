class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    
    respond_to do |format|
      format.html
      format.json { render :json => @photos }
    end
  end
end
