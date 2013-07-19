module SessionsHelper
  def admin?
    session[:admin].present?
  end

  def login
    session[:admin] = true
  end

  def logout
    session[:admin] = nil
  end
end
