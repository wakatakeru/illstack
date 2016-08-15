require 'rmagick'

class ImagesController < ApplicationController

  def index
    @images = Image.all
  end
  
  def show
    @image = Image.find(params[:id])
  end

  def new
    @image = Image.new
  end

  def create
    image = Image.new
    image.tile = params['image']['title']
    image.author_id = current_user

    file = params['image']['file']
    if file != nil
      content = file.read
      image.path      = "upload/content/#{Time.now.to_i}_#{current_user}.jpg"
      image.thumbnail = "upload/thumbnail/#{Time.now.to_i}_#{current_user}.jpg"
    
      File.open("upload/content/#{Time.now.to_i}_#{current_user}.jpg", "wb") do |f|
        f.write(content)
      end

      File.open("upload/thumbnail/#{Time.now.to_i}_#{current_user}.jpg", "wb") do |f|
        thumb = Magick::Image.from_blob(content).shift
        f.write(thumb.resize_to_fill!(120, 120).to_blob)
      end
    end
    
    if image.save
      redirect_to root_path, :notice => "投稿に成功しました"
    else
      render new_image_path, :alert => "投稿に失敗しました。\n内容を確認してください。"
    end
  end
  
  def edit
    @image = Image.find(params[:id])
  end

  def destroy
    @image = Image.find(params[:id])
    @image.destroy
  end





  
end
