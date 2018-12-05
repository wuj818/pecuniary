require 'rails_helper'

RSpec.describe 'Financial Assets' do
  describe 'GET index' do
    it 'returns a successful response' do
      expect(FinancialAsset).to receive(:includes).with(:snapshots).and_return mock_relation
      expect(mock_relation).to receive(:order).with(:name).and_return mock_relation

      get financial_assets_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET show' do
    it 'returns a successful response' do
      asset = stub_asset permalink: 'bank'
      expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return stub_asset

      get financial_asset_path(asset)

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login

        get new_financial_asset_path

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get new_financial_asset_path

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      let(:asset) { stub_asset }

      before do
        request_spec_login
        expect(FinancialAsset).to receive(:new).and_return asset
      end

      describe 'with valid params' do
        it 'creates a new asset and redirects to the assets index' do
          expect(asset).to receive(:save).and_return true

          post financial_assets_path, params: { financial_asset: { test: 1 } }

          expect(response).to redirect_to financial_assets_path
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new asset" do
          expect(asset.as_new_record).to receive(:save).and_return false

          post financial_assets_path, params: { financial_asset: { test: 1 } }

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:new)

        post financial_assets_path, params: { financial_asset: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset

        get edit_financial_asset_path(asset)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by)

        get edit_financial_asset_path(asset)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
      end

      describe 'with valid params' do
        it 'redirects to the asset' do
          expect(asset).to receive(:update).and_return true

          patch financial_asset_path(asset, financial_asset: { test: 1 })

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the asset" do
          expect(asset).to receive(:update).and_return false

          patch financial_asset_path(asset, financial_asset: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by)

        patch financial_asset_path(asset, financial_asset: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      it 'destroys the requested asset and redirects to the assets index' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset).to receive(:destroy).and_return true

        delete financial_asset_path(asset)

        expect(response).to redirect_to financial_assets_path
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by)

        delete financial_asset_path(asset)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
