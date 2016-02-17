class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all.alphabetize
    @title = "All Users"
  end

  def newsfeed
    @title = "Newsfeed"
    @receiver_id = params[:id]
    @posts = Post.order(created_at: :desc).includes(:creator).includes(:receiver)
  end

  def friends
    @users = current_user.friends
    @title = "Friends"
    render "index"
  end

  def friend_requests
    @users = current_user.requests_from
    @title = "Friend Requests"
    render "index"
  end

  def find_friends
    @users = current_user.no_friendship
    @title = "Find Friends"
    render "index"
  end
end
