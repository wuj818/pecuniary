# frozen_string_literal: true

module SystemSpecHelper
  def system_spec_login
    visit login_path
    fill_in "password", with: admin_password
    click_button "Login"
  end

  def admin_password
    Rails.application.credentials.password[Rails.env.to_sym]
  end
end
