# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :block_admin, only: %i[new create]

  def new; end

  def create
    if valid_password?
      login
      flash[:success] = "Logged in successfully."
      redirect_to root_url
    else
      flash.now[:danger] = "Incorrect password."
      render :new
    end
  end

  def destroy
    if admin?
      logout
      flash[:success] = "Logged out successfully."
    else
      flash[:info] = "You are not logged in."
    end

    redirect_to root_url
  end

  private

  def block_admin
    return unless admin?

    flash[:info] = "You are already logged in."
    redirect_to root_url
  end

  def valid_password?
    params[:password] == admin_password
  end
end
