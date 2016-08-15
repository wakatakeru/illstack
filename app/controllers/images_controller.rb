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
    image.title   = params['image']['title']
    image.comment = params['image']['comment']
    image.author_id = current_user.id
    
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
        f.write(thumb.resize_to_fill!(420, 210).to_blob)
      end
    end
    
    if image.save
      redirect_to root_path, :notice => "投稿に成功しました。"
    else
      render new_image_path, :alert => "投稿に失敗しました。\n内容を確認してください。"
    end
  end
  
  def edit
    @image = Image.find(params[:id])
  end

  def update
    image = Image.find(params[:id])
    image.title = params['image']['title']
    if image.save
      redirect_to root_path, :notice => "内容の変更に成功しました。"
    else
      render edit_image_path, :alert => "内容の変更に失敗しました。\n内容を確認してください。"
    end
  end
  
  def destroy
    image = Image.find(params[:id])
    image_path           = image.image
    image_thumbnail_path = image.thumbnail
    if image.destroy
      File.delete("public#{image_path}")
      File.delete("public#{image_thumbnail_path}")
      redirect_to root_path, :notice => "画像の削除に成功しました。"
    else
      render edit_image_path, :alert => "画像の削除に失敗しました。\n内容を確認してください。"
    end
  end  
end
