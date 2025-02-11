class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user&.id)
  end

  def show
    @user = User.includes(posts: [], profile_photo_attachment: :blob).find(params[:id])
    @friends = (@user.following_users + @user.followed_users).uniq
    @common_friends = (current_user.following_users + current_user.followed_users) & @friends
    Bugsnag.notify("Yes - bugsnag is working, from UsersController line#10 - Test error from user#show #{@user}")
  end

  def friends_index
    @friends = current_user.followed_users
  end

end
