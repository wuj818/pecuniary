require 'rails_helper'

RSpec.describe FinancialAssetsController do
  describe 'GET index' do
    it 'assigns all assets as @assets' do
      expect(FinancialAsset).to receive(:includes).with(:snapshots).and_return mock_relation
      expect(mock_relation).to receive(:order).with(:name).and_return mock_relation

      get :index

      expect(response).to render_template :index
      expect(assigns(:assets)).to eq mock_relation
    end
  end

  describe 'GET show' do
    it 'assigns the requested asset as @asset, its snapshots as @snapshots, and its contributions as @contributions' do
      asset = stub_asset permalink: 'bank'
      expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return stub_asset
      expect(asset).to receive(:snapshots).and_return mock_relation
      expect(asset).to receive(:contributions).and_return mock_relation
      expect(mock_relation).to receive(:order).with('date DESC').and_return mock_relation

      get :show, params: { id: asset.to_param }

      expect(response).to render_template :show
      expect(assigns(:asset)).to eq asset
      expect(assigns(:snapshots)).to eq mock_relation
      expect(assigns(:contributions)).to eq mock_relation
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'assigns a new asset as @asset' do
        controller.login

        get :new

        expect(response).to render_template :new
        expect(assigns(:asset)).to be_a_new FinancialAsset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      let(:asset) { stub_asset }

      before do
        controller.login
        expect(FinancialAsset).to receive(:new).and_return asset
      end

      describe 'with valid params' do
        it 'creates a new asset and redirects to the assets list' do
          expect(asset).to receive(:save).and_return true

          post :create, params: { financial_asset: { test: 1 } }

          expect(response).to redirect_to financial_assets_path
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          expect(asset).to receive(:save).and_return false

          post :create, params: { financial_asset: { test: 1 } }

          expect(response).to render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, params: { financial_asset: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      it 'assigns the requested asset as @asset' do
        controller.login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset

        get :edit, params: { id: asset.to_param }

        expect(response).to render_template :edit
        expect(assigns(:asset)).to eq asset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, params: { id: asset.to_param }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PUT update' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      before do
        controller.login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
      end

      describe 'with valid params' do
        it 'redirects to the asset' do
          expect(asset).to receive(:update).and_return true

          put :update, params: { id: asset.to_param, financial_asset: { test: 1 } }

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          expect(asset).to receive(:update).and_return false

          put :update, params: { id: asset.to_param, financial_asset: { test: 1 } }

          expect(response).to render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, params: { id: asset.to_param, financial_asset: { test: 1 } }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:asset) { stub_asset permalink: 'bank' }

    context 'when logged in' do
      it 'destroys the requested asset and redirects to the assets list' do
        controller.login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset).to receive(:destroy).and_return true

        delete :destroy, params: { id: asset.to_param }

        expect(response).to redirect_to financial_assets_path
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, params: { id: asset.to_param }

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
