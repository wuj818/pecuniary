# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    helper_method :admin?
  end

  def admin?
    cookies.encrypted[:admin] == admin_password
  end

  def authorize
    deny_access unless admin?
  end

  def deny_access
    flash[:warning] = "You must be logged in to access this page."
    redirect_to login_url
  end

  def login
    cookies.permanent.encrypted[:admin] = {
      value: admin_password,
      httponly: true
    }
  end

  def logout
    cookies.delete(:admin)
  end

  private

  def admin_password
    Rails.application.credentials.password[Rails.env.to_sym]
  end
end
