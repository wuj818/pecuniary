require 'rails_helper'

RSpec.describe SessionsController do
  describe 'GET new' do
    context 'when logged in' do
      it 'redirects to the home page' do
        controller.login

        get :new

        expect(response).to redirect_to root_path
        expect(flash[:info]).to match /already logged in/i
      end
    end

    context 'when logged out' do
      it "renders the 'new' template" do
        get :new

        expect(response).to render_template :new
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      it 'redirects to the home page' do
        controller.login

        post :create

        expect(response).to redirect_to root_path
        expect(flash[:info]).to match /already logged in/i
      end
    end

    context 'when logged out' do
      context 'with a valid password' do
        it 'logs in the admin and redirects to the home page' do
          post :create, session: { password: Rails.application.credentials.password[Rails.env.to_sym] }

          expect(response).to redirect_to root_path
          expect(flash[:success]).to match /successfully/i
          expect(controller).to be_admin
        end
      end

      context 'with an invalid password' do
        it "renders the 'new' template" do
          post :create, session: { password: 'test' }

          expect(response).to render_template :new
          expect(flash.now[:danger]).to match /incorrect/i
          expect(controller).to_not be_admin
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when logged in' do
      it 'logs out the admin and redirects to the home page' do
        controller.login

        delete :destroy

        expect(response).to redirect_to root_path
        expect(flash[:success]).to match /successfully/i
        expect(controller).to_not be_admin
      end
    end

    context 'when logged out' do
      it 'redirects to the home page' do
        delete :destroy

        expect(response).to redirect_to root_path
        expect(flash[:info]).to match /not logged in/i
        expect(controller).to_not be_admin
      end
    end
  end
end
