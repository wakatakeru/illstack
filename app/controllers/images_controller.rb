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
    image.title = params['image']['title']
    image.author_id = current_user

    file = params['image']['file']
    if file != nil
      content = file.read
      image.image     = "/upload/content/#{Time.now.to_i}_#{current_user.id}.jpg"
      image.thumbnail = "/upload/thumbnail/#{Time.now.to_i}_#{current_user.id}.jpg"
    
      File.open("public/upload/content/#{Time.now.to_i}_#{current_user.id}.jpg", "wb") do |f|
        f.write(content)
      end

      File.open("public/upload/thumbnail/#{Time.now.to_i}_#{current_user.id}.jpg", "wb") do |f|
        thumb = Magick::Image.from_blob(content).shift
        f.write(thumb.resize_to_fill!(240, 120).to_blob)
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
