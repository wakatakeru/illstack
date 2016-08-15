class HomeController < ApplicationController
  def index
    @images = Image.all
  end

  def show
    user = current_user
    @user = User.find(user.id)
    @image = Array.new
    Image.all.each do |item|
      @image.push(item) if item.author_id == user.id
    end
  end
  
end
