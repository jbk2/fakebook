include ActionView::Helpers::DateHelper

class PostsController < ApplicationController
  before_action :set_user, only: [:new, :create, :index]


  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_posts_path(@user, @post), notice: "Post was successfully created"
    else
      render 'new', unprocessable_entity: "Post was not created"
    end
  end

  def index
    @post = Post.new
    own_posts = current_user.posts
    following_posts = current_user.followed_users.map(&:posts).flatten
    @posts = (own_posts + following_posts).sort_by(&:created_at).reverse
  end

  private
  def set_user
    @user = current_user
  end

  def post_params
    params.require(:post).permit(:title, :body, photos: [] )
  end
end
