require 'spec_helper'

describe SessionsController do
  describe 'GET new' do
    context 'when logged in' do
      it 'redirects to the home page' do
        controller.login

        get :new

        response.should redirect_to root_path
        flash[:info].should match /already logged in/i
      end
    end

    context 'when logged out' do
      it "renders the 'new' template" do
        get :new

        response.should render_template :new
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      it 'redirects to the home page' do
        controller.login

        post :create

        response.should redirect_to root_path
        flash[:info].should match /already logged in/i
      end
    end

    context 'when logged out' do
      context 'with a valid password' do
        it 'logs in the admin and redirects to the home page' do
          post :create, session: { password: Figaro.env.pecuniary_password }

          response.should redirect_to root_path
          flash[:success].should match /successfully/i
          controller.should be_admin
        end
      end

      context 'with an invalid password' do
        it "renders the 'new' template" do
          post :create, session: { password: 'test' }

          response.should render_template :new
          flash.now[:error].should match /incorrect/i
          controller.should_not be_admin
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      it 'logs out the admin and redirects to the home page' do
        controller.login

        delete :destroy

        response.should redirect_to root_path
        flash[:success].should match /successfully/i
        controller.should_not be_admin
      end
    end

    context 'when logged out' do
      it 'redirects to the home page' do
        delete :destroy

        response.should redirect_to root_path
        flash[:info].should match /not logged in/i
        controller.should_not be_admin
      end
    end
  end
end
