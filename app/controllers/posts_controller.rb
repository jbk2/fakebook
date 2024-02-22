class PostsController < ApplicationController
  def new
  end

  def create
  end

  def index
    @posts = Post.all
  end
end
