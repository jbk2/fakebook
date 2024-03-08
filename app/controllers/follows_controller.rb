class FollowsController < ApplicationController
  include PostsHandler
  
  def create
    @follow = Follow.new(follow_params)
    followed_user = User.find(params[:follow][:followed_id])
    
    if @follow.save
      flash.now[:notice] = "You are now following #{followed_user.username}"
      streams = generate_streams(followed_user, "unfollow_button")
      render_streams(streams)
    else
      redirect_to users_path, notice: "Cannot create a follow for this user; #{params[:follow][:followed_id]}"
    end
  end

  def destroy
    followed_user = User.find(params[:follow][:followed_id] )
    @follow = Follow.find_by(follower_id: current_user.id, followed_id: followed_user.id)

    if @follow.destroy
      flash.now[:notice] = "You are no longer following #{followed_user.username}"
      streams = generate_streams(followed_user, "follow_button")
      render_streams(streams)
    else
      flash.now[:alert] = "Either Follow not found or unable to be destroyed for #{followed_user.username}"
      redirect_to users_path
    end
  end

  private 
  def follow_params
    params.require(:follow).permit(:follower_id, :followed_id)
  end

  def generate_streams(followed_user, partial_name)
    if params[:context] == "post_card"
      followed_user.posts.map do |post|
        turbo_stream.update(
          "follow_action_button_#{params[:follow][:followed_id]}_#{post.id}",
          partial: "users/#{partial_name}",
          locals: { user: followed_user, context: params[:context] }
        )
      end
    else
      turbo_stream.update(
        "follow_action_button_#{params[:follow][:followed_id]}",
        partial: "users/#{partial_name}",
        locals: { user: followed_user, context: params[:context] }
      )
    end
  end

  def render_streams(streams)
    streams << turbo_stream.update("flash_messages", partial: "layouts/flash")
    respond_to do |format|
      format.html { redirect_to users_path }
      format.turbo_stream { render turbo_stream: streams }
    end
  end

end