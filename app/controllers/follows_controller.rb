class FollowsController < ApplicationController
  include PostsHandler
  def create
    @follow = Follow.new(follow_params)
    followed_user = User.find(params[:follow][:followed_id])
    streams = []
    
    if @follow.save
      flash.now[:notice] = "You are now following #{followed_user.username}"

      if params[:context] == "post_card"
        streams = followed_user.posts.map do |post|
          turbo_stream.update(
            "follow_action_button_#{params[:follow][:followed_id]}_#{post.id}",
            partial: "users/unfollow_button",
            locals: { user: followed_user, context: params[:context] }
          )
        end
      end

      if params[:context] == "user_card"
        streams << turbo_stream.update(
          "follow_action_button_#{params[:follow][:followed_id]}",
          partial: "users/unfollow_button",
          locals: { user: followed_user, context: params[:context] }
        )
      end

      streams << turbo_stream.update("flash_messages", partial: "layouts/flash")

      respond_to do |format|
        format.html { redirect_to users_path }
        format.turbo_stream { render turbo_stream: streams }
      end
    else
      redirect_to users_path, notice: "Cannot create a follow for this user; #{params[:follow][:followed_id]}"
    end
  end

  def destroy
    followed_user = User.find(params[:follow][:followed_id] )
    @follow = Follow.find_by(follower_id: current_user.id, followed_id: followed_user.id)
    streams = []

    if @follow.destroy
      flash.now[:notice] = "You are no longer following #{followed_user.username}"   

      if params[:context] == "post_card"
        streams = followed_user.posts.map do |post|
          turbo_stream.update(
            "follow_action_button_#{params[:follow][:followed_id]}_#{post.id}",
            partial: "users/follow_button",
            locals: { user: followed_user, context: params[:context] }
            )
        end
      end

      if params[:context] == "user_card"
        streams << turbo_stream.update(
          "follow_action_button_#{params[:follow][:followed_id]}",
          partial: "users/follow_button",
          locals: { user: followed_user, context: params[:context] }
        )
      end

      streams << turbo_stream.update("flash_messages", partial: "layouts/flash")

      respond_to do |format|
        format.html { redirect_to users_path }
        format.turbo_stream { render turbo_stream: streams }
      end
    else
      flash.now[:alert] = "Either Follow not found or unable to be destroyed for #{followed_user.username}"
      respond_to do |format|
        format.html { redirect_to users_path }
      end
    end
  end

  private 
  def follow_params
    params.require(:follow).permit(:follower_id, :followed_id)
  end

end