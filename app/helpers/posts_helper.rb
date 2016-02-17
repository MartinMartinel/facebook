module PostsHelper
  def post_likers(post, likes)
    you_liked = !find_like(post.id, "Post").nil?

    if likes == 1
      you_liked ? "You like this" : "1 person likes this"
    else
      you_liked ? "You and #{pluralize(likes - 1, 'other')} like this"
      : "#{likes} people like this"
    end
  end
end
