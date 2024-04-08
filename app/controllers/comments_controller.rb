class CommentsController < ApplicationController
  before_action :set_post, only: [:new, :create]

  def new
    @comment = @post.comments.build
    render turbo_stream: turbo_stream.append("new-post-#{params[:post_id]}-comment", partial: 'comments/form', locals: { post: @post, comment: @comment })
  end
  
  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("post-#{params[:post_id]}-comments", partial: 'comments/comment',
              locals: { comment: @comment }),
            turbo_stream.replace("post-#{params[:post_id]}-comment-count", partial: 'comments/count',
              locals: { post: @post }),
            turbo_stream.replace("new-post-#{params[:post_id]}-comment", partial: 'comments/form',
              locals: { post: @post, comment: @post.comments.build })
          ]
        end
        format.html { redirect_to user_posts_path(current_user), notice: "Comment was created" }
      end
    else
      error_message = @comment.errors.full_messages.to_sentence
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

  def comment_params
    params.require(:comment).permit(:post_id, :body).merge(user_id: current_user.id)
  end

end
