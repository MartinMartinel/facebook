module UsersHelper
  def get_status receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "Status" : "Post"
  end

  def get_placeholder receiver_id
    (receiver_id.to_s == current_user.id.to_s) ? "What's on your mind?" :
        "Write something..."
  end

  def friend_status_with(user)
    return if current_user == user
    if current_user.has_friend_request_from?(user)
      render "users/request_received", user: user
    elsif user.has_friend_request_from?(current_user)
      render "users/request_sent"
    elsif current_user.friends_with?(user)
      render "users/unfriend", user: user
    else
      render "users/add_friend", user: user
    end
  end

  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def image_for(user, options = { size: 50, img_class: "mid-img" })
    gravatar_id  = Digest::MD5::hexdigest(user.email.downcase)
    # size         = options[:size]
    img_class    = options[:img_class]
    size = case img_class
             when "v-lg-img" then 160
             when "lg-img"   then 75
             when "md-img"   then 40
             when "sm-img"   then 32
             when "v-sm-img" then 19
             else 50
           end

    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.first_name, class: img_class)
  end

end
