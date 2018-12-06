RSpec.describe 'Asset Snapshots' do
  describe 'GET show' do
    it 'returns a successful response' do
      snapshot = stub_asset_snapshot
      expect(AssetSnapshot).to receive(:find_by).with(permalink: snapshot.to_param).and_return snapshot

      get asset_snapshot_path(snapshot)

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET new' do
    let(:asset) { stub_asset }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset.snapshots).to receive(:build).and_return stub_asset_snapshot.as_new_record

        get new_financial_asset_snapshot_path(asset)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get new_financial_asset_snapshot_path(asset)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'POST create' do
    let(:asset) { stub_asset }
    let(:snapshot) { stub_asset_snapshot asset: asset }

    context 'when logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by).with(permalink: asset.to_param).and_return asset
        expect(asset.snapshots).to receive(:build).and_return snapshot
      end

      describe 'with valid params' do
        it 'creates a new snapshot and redirects to its asset' do
          expect(snapshot).to receive(:save).and_return true

          post financial_asset_snapshots_path(asset, asset_snapshot: { test: 1 })

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new snapshot" do
          expect(snapshot.as_new_record).to receive(:save).and_return false

          post financial_asset_snapshots_path(asset, asset_snapshot: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post financial_asset_snapshots_path(asset, asset_snapshot: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'GET edit' do
    let(:snapshot) { stub_asset_snapshot }

    context 'when logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(AssetSnapshot).to receive(:find_by).with(permalink: snapshot.to_param).and_return snapshot

        get edit_asset_snapshot_path(snapshot)

        expect(response).to have_http_status :ok
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get edit_asset_snapshot_path(snapshot)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'PATCH update' do
    let(:snapshot) { stub_asset_snapshot }

    context 'when logged in' do
      before do
        request_spec_login
        expect(AssetSnapshot).to receive(:find_by).with(permalink: snapshot.to_param).and_return snapshot
      end

      describe 'with valid params' do
        it 'redirects to the snapshot' do
          expect(snapshot).to receive(:update).and_return true

          patch asset_snapshot_path(snapshot, asset_snapshot: { test: 1 })

          expect(response).to redirect_to snapshot
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the snapshot" do
          expect(snapshot).to receive(:update).and_return false

          patch asset_snapshot_path(snapshot, asset_snapshot: { test: 1 })

          expect(response).to have_http_status :ok
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(AssetSnapshot).not_to receive(:find_by)

        patch asset_snapshot_path(snapshot, asset_snapshot: { test: 1 })

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:snapshot) { stub_asset_snapshot }

    context 'when logged in' do
      it 'destroys the requested snapshot and redirects to its asset' do
        request_spec_login
        expect(AssetSnapshot).to receive(:find_by).with(permalink: snapshot.to_param).and_return snapshot
        expect(snapshot).to receive(:destroy).and_return true

        delete asset_snapshot_path(snapshot)

        expect(response).to redirect_to snapshot.asset
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        expect(AssetSnapshot).not_to receive(:find_by)

        delete asset_snapshot_path(snapshot)

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
