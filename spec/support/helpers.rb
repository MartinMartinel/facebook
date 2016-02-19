module Helpers
  def log_in(email, pwd)
    visit 'signup'
    within('#header-form') do
      fill_in 'Email',    with: email
      fill_in 'Password', with: pwd
    end
    click_on 'Sign In'
  end

  def sign_up(email, pwd)
    visit 'signup'
    within('#new_user') do
      fill_in 'Email',      with: email
      fill_in 'Password',   with: pwd
      fill_in 'Password confirmation', with: pwd
    end
    click_on 'Sign Up'
  end

  def make_friends(user1, user2)
    user1.send_friend_request_to(user2)
    user2.accept_friend_request_from(user1)
  end

  def make_friends2(user, friend)
    click_on "All Users", match: :first
    within("#friend-status-#{friend.id}") do
      click_on "Add Friend"
    end
    click_on "Log Out", match: :first

    log_in(friend.email, friend.password)
    click_on("Friend Requests")
    click_on("Accept")
    click_on "Log Out", match: :first
    log_in(user.email, user.password)
  end

  def friend_request_to_from(user, friender)
    click_on "Log Out", match: :first

    log_in(friender.email, friender.password)
    click_on "All Users", match: :first
    within("#friend-status-#{user.id}") do
      click_on "Add Friend"
    end
    click_on "Log Out", match: :first

    log_in(user.email, user.password)
  end

  def friend_request_from_to(user, friended)
    click_on "All Users", match: :first
    within("#friend-status-#{friended.id}") do
      click_on "Add Friend"
    end
  end
end
