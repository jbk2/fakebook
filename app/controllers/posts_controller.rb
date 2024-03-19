include ActionView::Helpers::DateHelper

class PostsController < ApplicationController
include PostsHandler
  before_action :set_user, only: [:new, :create, :index]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      if @post.photos.present?
        @post.photos.each do |photo|
          ProcessImageJob.perform_later(photo.blob.id, 'photos')
        end
      end
      respond_to do |format|
        format.html { redirect_to user_posts_path(@user, @post), notice: "Post was successfully created" }
        format.turbo_stream
      end
    else
      render 'new', unprocessable_entity: "Post was not created"
    end
  end

  def index
    @post = Post.new
    @posts = current_user_and_following_user_posts
    @pagy, @posts = pagy_countless(@posts)
  rescue Pagy::OverflowError
    redirect_to root_path, alert: "Page number is too high"

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private
  def set_user
    @user = current_user
  end

  def post_params
    params.require(:post).permit(:title, :body, photos: [] )
  end
end
