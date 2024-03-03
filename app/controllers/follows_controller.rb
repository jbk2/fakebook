class FollowsController < ApplicationController
  def create
    @follow = Follow.new(follow_params)
    followed_user = User.find(params[:follow][:followed_id])
    if @follow.save
      flash.now[:notice] = "You are now following #{followed_user.username}"
      respond_to do |format|
        format.html { redirect_to users_path, notice: "You are now following #{followed_user.username}" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("follow_action_button_#{params[:follow][:followed_id]}",
              partial: "users/unfollow_button", locals: { user: followed_user }),
            turbo_stream.update("flash_messages", partial: "layouts/flash")
          ]
        end
      end
    else
      redirect_to users_path, notice: "Cannot create a follow for this user; #{params[:follow][:followed_id]}"
    end
  end

  def destroy
    followed_user = User.find(params[:id])

    @follow = Follow.find_by(follower_id: current_user.id, followed_id: followed_user.id)
    if @follow.destroy
      flash.now[:notice] = "You are no longer following this user"
      respond_to do |format|
        format.html { redirect_to users_path, notice: "You are no longer following this user" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("follow_action_button_#{params[:follow][:followed_id]}",
              partial: "users/follow_button", locals: { user: followed_user }),
            turbo_stream.update("flash_messages", partial: "layouts/flash")
          ] 
        end
      end
    else
      flash.now[:alert] = "You are no longer following this user"
      respond_to do |format|
        format.html { redirect_to users_path, alert: "Either Follow not found or unable to be destroyed" }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.update("follow_action_button_#{params[:follow][:followed_id]}",
              partial: "users/follow_button", locals: { user: followed_user }),
            turbo_stream.update("flash_messages", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  private 
  def follow_params
    params.require(:follow).permit(:follower_id, :followed_id)
  end

end