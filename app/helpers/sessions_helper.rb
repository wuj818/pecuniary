module SessionsHelper
  def admin?
    session[:admin].present?
  end

  def authorize
    deny_access unless admin?
  end

  def deny_access
    flash[:warning] = 'You must be logged in to access this page.'
    redirect_to login_path
  end

  def login
    session[:admin] = true
  end

  def logout
    session[:admin] = nil
  end
end
