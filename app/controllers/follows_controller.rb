class FollowsController < ApplicationController
  def create
    @follow = Follow.new(follow_params)
    followed_user = User.find(params[:follow][:followed_id])
    if @follow.save
      respond_to do |format|
        format.html { redirect_to users_path, notice: "You are now following #{followed_user.username}" }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("follow_button_#{params[:follow][:followed_id]}", partial: "users/follow_button", locals: { user: followed_user, follow: @follow })
        end
      end
    else
      redirect_to users_path, notice: "Cannot create a follow for this user; #{params[:follow][:followed_id]}"
    end
  end

  def destroy
    @follow = Follow.find(params[:id])
    puts "destroying follow"
  end

  private 
  def follow_params
    params.require(:follow).permit(:follower_id, :followed_id)
  end
end
