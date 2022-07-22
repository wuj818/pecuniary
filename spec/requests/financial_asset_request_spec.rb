# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/financial-assets" do
  describe "GET /index" do
    it "returns a successful response" do
      get financial_assets_url

      expect(response).to be_successful
    end
  end

  describe "GET show" do
    let(:asset) { create(:asset) }

    it "returns a successful response" do
      get financial_asset_url(asset)

      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    let(:request!) { get new_financial_asset_url }

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
    let(:request!) { post financial_assets_url, params: params }

    let(:params) { { financial_asset: asset_params } }
    let(:asset_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:asset_params) { attributes_for(:asset) }

        it "creates a new asset and redirects to the assets index" do
          expect { request! }.to change(FinancialAsset, :count).by(1)

          expect(response).to redirect_to(financial_assets_url)
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe "with invalid params" do
        let(:asset_params) { attributes_for(:invalid_asset) }

        it "doesn't create a new asset" do
          expect { request! }.not_to change(FinancialAsset, :count)

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
    let(:asset) { create(:asset) }

    let(:request!) { get edit_financial_asset_url(asset) }

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
    let!(:asset) { create(:asset) }

    let(:request!) do
      patch financial_asset_url(asset), params: params
      asset.reload
    end

    let(:params) { { financial_asset: asset_params } }
    let(:asset_params) { nil }

    context "when logged in" do
      before { request_spec_login }

      describe "with valid params" do
        let(:new_name) { asset.name.reverse }

        let(:asset_params) { { name: new_name } }

        it "redirects to the asset" do
          expect { request! }.to change(asset, :name).to(new_name)

          expect(response).to redirect_to(asset)
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe "with invalid params" do
        let(:asset_params) { attributes_for(:invalid_asset) }

        it "doesn't update the asset" do
          expect { request! }.not_to change(asset.reload, :attributes)

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
    let!(:asset) { create(:asset) }

    let(:request!) { delete financial_asset_url(asset) }

    context "when logged in" do
      it "destroys the requested asset and redirects to the assets index" do
        request_spec_login

        expect { request! }.to change(FinancialAsset, :count).by(-1)

        expect(response).to redirect_to(financial_assets_url)
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
