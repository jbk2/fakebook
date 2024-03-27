class LikesController < ApplicationController

  before_action :set_post
  
  def create
    @like = @post.likes.build(user: current_user)

    if @like.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post-#{params[:post_id]}-like-count",
          partial: "likes/count", locals: { post: @post })
        end
        format.html { redirect_to user_posts_path(current_user), notice: "Post was liked" } # html should redirect to the liked post?
      end
    else
      error_message = @like.errors.full_messages.to_sentence
      respond_to do |format|
        format.html do
          flash[:alert] = error_message
          redirect_to user_posts_path(current_user)
        end 
        format.turbo_stream do
          flash.now[:alert] = error_message
          render turbo_stream: turbo_stream.update('flash_messages', partial: 'layouts/flash')
        end
      end
    end
  end

  private
  def set_post
    @post = Post.find(params[:post_id])
  end

  def like_params
    params.require(:like).permit(:post_id, :user_id)
  end
end
