module RequestSpecHelper
  def request_spec_login
    post sessions_path, params: { password: Rails.application.credentials.password[Rails.env.to_sym] }
  end

  def admin_cookie
    response.cookies['admin']
  end
end
