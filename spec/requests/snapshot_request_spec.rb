RSpec.describe 'Snapshot Requests' do
  describe 'GET show' do
    let(:snapshot) { stub_snapshot }

    it 'returns a successful response' do
      expect(Snapshot).to receive(:find_by!).with(permalink: snapshot.to_param).and_return snapshot

      get snapshot_path(snapshot)

      expect(response).to be_successful
    end
  end

  describe 'GET new' do
    let(:asset) { stub_asset }

    let(:request!) { get new_financial_asset_snapshot_path(asset) }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
        expect(asset.snapshots).to receive(:build).and_return stub_snapshot.as_new_record

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
    let(:snapshot) { stub_snapshot asset: asset }

    let(:request!) { post financial_asset_snapshots_path(asset, snapshot: { test: 1 }) }

    context 'logged in' do
      before do
        request_spec_login
        expect(FinancialAsset).to receive(:find_by!).with(permalink: asset.to_param).and_return asset
        expect(asset.snapshots).to receive(:build).and_return snapshot
      end

      describe 'with valid params' do
        it 'creates a new snapshot and redirects to its asset' do
          expect(snapshot).to receive(:save).and_return true

          request!

          expect(response).to redirect_to asset
          expect(flash[:success]).to match(/created/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't create a new snapshot" do
          expect(snapshot.as_new_record).to receive(:save).and_return false

          request!

          expect(response).to be_successful
        end
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

  describe 'GET edit' do
    let(:snapshot) { stub_snapshot }

    let(:request!) { get edit_snapshot_path(snapshot) }

    context 'logged in' do
      it 'returns a successful response' do
        request_spec_login
        expect(Snapshot).to receive(:find_by!).with(permalink: snapshot.to_param).and_return snapshot

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

  describe 'PATCH update' do
    let(:snapshot) { stub_snapshot }

    let(:request!) { patch financial_asset_snapshot_path(snapshot.asset, snapshot, snapshot: { test: 1 }) }

    context 'logged in' do
      before do
        request_spec_login
        expect(Snapshot).to receive(:find_by!).with(permalink: snapshot.to_param).and_return snapshot
      end

      describe 'with valid params' do
        it 'redirects to the snapshot' do
          expect(snapshot).to receive(:update).and_return true

          request!

          expect(response).to redirect_to snapshot
          expect(flash[:success]).to match(/updated/i)
        end
      end

      describe 'with invalid params' do
        it "doesn't update the snapshot" do
          expect(snapshot).to receive(:update).and_return false

          request!

          expect(response).to be_successful
        end
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(Snapshot).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end

  describe 'DELETE destroy' do
    let(:snapshot) { stub_snapshot }

    let(:request!) { delete snapshot_path(snapshot) }

    context 'logged in' do
      it 'destroys the requested snapshot and redirects to its asset' do
        request_spec_login
        expect(Snapshot).to receive(:find_by!).with(permalink: snapshot.to_param).and_return snapshot
        expect(snapshot).to receive(:destroy).and_return true

        request!

        expect(response).to redirect_to snapshot.asset
        expect(flash[:success]).to match(/deleted/i)
      end
    end

    context 'logged out' do
      it 'redirects to the login page' do
        expect(Snapshot).not_to receive(:find_by!)

        request!

        expect(response).to redirect_to login_path
        expect(flash[:warning]).to match(/must be logged in/i)
      end
    end
  end
end
