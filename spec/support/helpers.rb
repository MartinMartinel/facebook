module Helpers
  def log_in(email,pwd)
    visit 'signup'
    within("#header-form") do
      fill_in "Email",    with: email
      fill_in "Password", with: pwd
    end
    click_on "Sign In"
  end

  def sign_up(email, pwd)
    visit 'signup'
    within("#new_user") do
      fill_in "Email",      with: email
      fill_in "Password",   with: pwd
      fill_in "Password confirmation", with: pwd
    end
    click_on "Sign Up"
  end

  def make_friends(user1, user2)
    user1.send_friend_request_to(user2)
    user2.accept_friend_request_from(user1)
  end
end
