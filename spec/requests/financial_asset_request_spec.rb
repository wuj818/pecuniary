RSpec.describe 'Financial Asset Requests' do
  describe 'GET index' do
    it 'returns a successful response' do
      get financial_assets_path

      expect(response).to be_successful
    end
  end

  describe 'GET show' do
    let(:asset) { stub_asset }

    it 'returns a successful response' do
      expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return stub_asset

      get financial_asset_path(asset)

      expect(response).to be_successful
    end
  end

  describe 'GET new' do
    let(:request!) { get new_financial_asset_path }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login

        request!

        expect(response).to be_successful
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    let(:asset) { stub_asset }

    let(:request!) { post financial_assets_path, params: { financial_asset: { test: 1 } } }

    context 'logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:new).and_return asset
      end

      describe 'with valid params' do
        it 'creates a new asset and redirects to the assets index' do
          expect(asset).to receive(:save).and_return true

          request!

          expect(response).to redirect_to financial_assets_path
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new asset" do
          expect(asset.as_new_record).to receive(:save).and_return false

          request!

          expect(response).to be_successful
        end
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(Milestone).not_to receive(:new)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:asset) { stub_asset }

    let(:request!) { get edit_financial_asset_path(asset) }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset

        request!

        expect(response).to be_successful
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:asset) { stub_asset }

    let(:request!) { patch financial_asset_path(asset, financial_asset: { test: 1 }) }

    context 'logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
      end

      describe 'with valid params' do
        it 'redirects to the asset' do
          expect(asset).to receive(:update).and_return true

          request!

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the asset" do
          expect(asset).to receive(:update).and_return false

          request!

          expect(response).to be_successful
        end
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:asset) { stub_asset }

    let(:request!) { delete financial_asset_path(asset) }

    context 'logged in' do
      it 'destroys the requested asset and redirects to the assets index' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
        expect(asset).to receive(:destroy).and_return true

        request!

        expect(response).to redirect_to financial_assets_path
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(FinancialAsset).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
