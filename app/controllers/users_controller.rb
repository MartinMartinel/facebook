class UsersController < ApplicationController
  before_action :authenticate_user!
  include UsersHelper

  def index
    @users = User.all.alphabetize
    @title = "All Users"
  end

  def newsfeed
    @title = "Newsfeed"
    @receiver_id = params[:id]
    @posts = Post.order(created_at: :desc).includes(:creator).includes(:receiver).includes(:comments)
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

  def timeline
    @receiver_id = params[:id]
    @label       = get_status(@receiver_id)
    @placeholder = get_placeholder(@receiver_id)
    @posts       = Post.all.order(created_at: :desc).limit(1)
    render layout: "profiles"
  end
end
