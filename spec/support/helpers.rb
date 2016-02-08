module Helpers
  def log_in(email,pwd)
    visit 'login'
    within("#new_user") do
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
end
