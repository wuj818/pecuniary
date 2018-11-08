module SessionsHelper
  def admin?
    cookies.signed[:admin] == Rails.application.credentials.password[Rails.env.to_sym]
  end

  def authorize
    deny_access unless admin?
  end

  def deny_access
    flash[:warning] = 'You must be logged in to access this page.'
    redirect_to login_path
  end

  def login
    cookies.permanent.signed[:admin] = Rails.application.credentials.password[Rails.env.to_sym]
  end

  def logout
    cookies.delete :admin
  end
end
