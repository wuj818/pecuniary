# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session Requests" do
  describe "GET new" do
    let(:request!) { get login_path }

    context "when logged in" do
      it "redirects to the home page" do
        request_spec_login

        request!

        expect(response).to redirect_to root_path
      end
    end

    context "when logged out" do
      it "returns a successful response" do
        request!

        expect(response).to be_successful
      end
    end
  end

  describe "POST create" do
    let(:password) { Rails.application.credentials.password[Rails.env.to_sym] }

    let(:request!) do
      lambda do |password = "wrong"|
        post sessions_path, params: { password: password }
      end
    end

    context "when logged in" do
      it "redirects to the home page" do
        request_spec_login

        request!.call password

        expect(response).to redirect_to root_path
        expect(flash[:info]).to match(/already logged in/i)
      end
    end

    context "when logged out" do
      context "with a valid password" do
        it "logs in the admin and redirects to the home page" do
          request!.call password

          expect(response).to redirect_to root_path
          expect(flash[:success]).to match(/successfully/i)
          expect(admin_cookie).to be_present
        end
      end

      context "with an invalid password" do
        it "doesn't login the admin" do
          request!.call

          expect(response).to be_successful
          expect(flash.now[:danger]).to match(/incorrect/i)
          expect(admin_cookie).to be_blank
        end
      end
    end
  end

  describe "DELETE destroy" do
    let(:request!) { delete logout_path }

    after do
      expect(response).to redirect_to root_path
      expect(admin_cookie).to be_blank
    end

    context "when logged in" do
      it "logs out the admin and redirects to the home page" do
        request_spec_login

        request!

        expect(flash[:success]).to match(/successfully/i)
      end
    end

    context "when logged out" do
      it "redirects to the home page" do
        request!

        expect(flash[:info]).to match(/not logged in/i)
      end
    end
  end
end
