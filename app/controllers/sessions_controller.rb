class SessionsController < ApplicationController
  def new
    if admin?
      flash[:info] = 'You are already logged in.'
      redirect_to root_path
    end
  end

  def create
    if admin?
      flash[:info] = 'You are already logged in.'
      redirect_to root_path and return
    end

    if params[:session][:password] == Figaro.env.pecuniary_password
      login
      flash[:success] = 'Logged in successfully.'
      redirect_to root_path
    else
      flash.now[:error] = 'Incorrect password.'
      render :new
    end
  end

  def destroy
    if admin?
      logout
      flash[:success] = 'Logged out successfully.'
    else
      flash[:info] = 'You are not logged in.'
    end

    redirect_to root_path
  end
end
