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
    @posts = Post.all
  end

  private
  def set_user
    @user = current_user
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
