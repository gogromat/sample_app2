include ApplicationHelper
#includes full_title code from app/helpers
RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error',text: message)
  end
end

def valid_signin(user)
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end


def valid_signup
  fill_in "Name",                  with: "Example User"
  #only 1 at the moment        ([a..z].shuffle * 10).join
  fill_in "Email",                 with: "user@example.com"
  fill_in "Password",              with: "foobar"
  fill_in "Confirmation",          with: "foobar"
end