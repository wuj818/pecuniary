require 'spec_helper'

describe AssetSnapshotsController do
  describe 'GET show' do
    it 'assigns the requested snapshot as @snapshot and its asset as @asset' do
      snapshot = stub_asset_snapshot(permalink: 'bank-july-2010')
      AssetSnapshot.should_receive(:find_by_permalink).and_return(snapshot)

      get :show, id: snapshot.to_param

      response.should render_template :show
      assigns(:snapshot).should == snapshot
      assigns(:asset).should == snapshot.asset
    end
  end

  describe 'GET new' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'assigns a new snapshot as @snapshot' do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
        @asset.snapshots.should_receive(:build).and_return(stub_asset_snapshot(new_record?: true, asset: @asset))

        get :new, financial_asset_id: @asset.to_param

        response.should render_template :new
        assigns(:snapshot).should be_a_new AssetSnapshot
        assigns(:snapshot).asset.should == @asset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new, financial_asset_id: @asset.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      before do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
        @asset.snapshots.should_receive(:build).and_return(stub_asset_snapshot(new_record?: true, asset: @asset))
      end

      describe 'with valid params' do
        it 'creates a new snapshot and redirects to its asset' do
          AssetSnapshot.any_instance.should_receive(:save).and_return(true)

          post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

          response.should redirect_to @asset
          flash[:success].should match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          AssetSnapshot.any_instance.should_receive(:save).and_return(false)

          post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

          response.should render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, financial_asset_id: @asset.to_param, asset_snapshot: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'assigns the requested snapshot as @snapshot' do
        controller.login
        AssetSnapshot.should_receive(:find_by_permalink).and_return(@snapshot)

        get :edit, id: @snapshot.to_param

        response.should render_template :edit
        assigns(:snapshot).should == @snapshot
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @snapshot.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      before do
        controller.login
        AssetSnapshot.should_receive(:find_by_permalink).and_return(@snapshot)
      end

      describe 'with valid params' do
        it 'redirects to the snapshot' do
          @snapshot.should_receive(:update_attributes).and_return(true)

          put :update, id: @snapshot.to_param, asset_snapshot: {}

          response.should redirect_to @snapshot
          flash[:success].should match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          @snapshot.should_receive(:update_attributes).and_return(false)

          put :update, id: @snapshot.to_param, asset_snapshot: {}

          response.should render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @snapshot.to_param, asset_snapshot: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @asset = stub_asset(permalink: 'bank')
      @snapshot = stub_asset_snapshot(permalink: 'bank-july-2010', asset: @asset)
    end

    context 'when logged in' do
      it 'destroys the requested snapshot and redirects to its asset' do
        controller.login
        AssetSnapshot.should_receive(:find_by_permalink).and_return(@snapshot)
        @snapshot.should_receive(:destroy).and_return(true)

        delete :destroy, id: @snapshot.to_param

        response.should redirect_to @asset
        flash[:success].should match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @snapshot.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end
end
