module SystemSpecHelper
  def system_spec_login
    visit login_path
    fill_in "password", with: Rails.application.credentials.password[Rails.env.to_sym]
    click_button "Login"
  end
end
