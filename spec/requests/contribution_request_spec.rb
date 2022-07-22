# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/contributions" do
  describe "GET /index" do
    it "returns a successful response" do
      get contributions_url

      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    let(:contribution) { create(:contribution) }

    it "returns a successful response" do
      get contribution_url(contribution)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    let(:asset) { create(:asset) }

    let(:request!) { get new_financial_asset_contribution_url(asset) }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "POST /create" do
    let(:asset) { create(:asset) }

    let(:request!) do
      post financial_asset_contributions_url(asset), params: params
    end

    let(:params) { { contribution: contribution_params } }
    let(:contribution_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:contribution_params) { attributes_for(:contribution) }

        it "creates a new contribution and redirects to its asset" do
          expect { request! }.to change(Contribution, :count).by(1)

          expect(response).to redirect_to(asset)
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe "with invalid params" do
        let(:contribution_params) { attributes_for(:invalid_contribution) }

        it "doesn't create a new contribution" do
          expect { request! }.not_to change(Contribution, :count)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "GET /edit" do
    let(:contribution) { create(:contribution) }

    let(:request!) { get edit_contribution_url(contribution) }

    context "when logged in" do
      it "returns a successful response" do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "PATCH /update" do
    let!(:contribution) { create(:contribution) }
    let(:asset) { contribution.asset }

    let(:request!) do
      patch financial_asset_contribution_url(asset, contribution), params: params
      contribution.reload
    end

    let(:params) { { contribution: contribution_params } }
    let(:contribution_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:new_amount) { contribution.amount + 1 }

        let(:contribution_params) { { amount: new_amount } }

        it "redirects to the contribution" do
          expect { request! }.to change(contribution, :amount).to(new_amount)

          expect(response).to redirect_to(contribution)
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe "with invalid params" do
        let(:contribution_params) { attributes_for(:invalid_contribution) }

        it "doesn't update the contribution" do
          expect { request! }.not_to change(contribution.reload, :attributes)

          expect(response).to be_successful
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:contribution) { create(:contribution) }
    let(:asset) { contribution.asset }

    let(:request!) { delete contribution_url(contribution) }

    context "when logged in" do
      it "destroys the requested contribution and redirects to its asset" do
        request_spec_login

        expect { request! }.to change(Contribution, :count).by(-1)

        expect(response).to redirect_to(asset)
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        request!

        expect(response).to redirect_to(login_url)
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
