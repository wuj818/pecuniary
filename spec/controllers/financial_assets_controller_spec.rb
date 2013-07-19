require 'spec_helper'

describe FinancialAssetsController do
  describe 'GET index' do
    it 'assigns all assets as @assets' do
      FinancialAsset.should_receive(:includes).with(:snapshots).and_return(mock_relation)
      mock_relation.should_receive(:order).with(:name).and_return(mock_relation)

      get :index

      response.should render_template :index
      assigns(:assets).should == mock_relation
    end
  end

  describe 'GET show' do
    it 'assigns the requested asset as @asset, its snapshots as @snapshots, and its contributions as @contributions' do
      asset = stub_asset(permalink: 'bank')
      FinancialAsset.should_receive(:find_by_permalink).and_return(stub_asset)
      asset.should_receive(:snapshots).and_return(mock_relation)
      asset.should_receive(:contributions).and_return(mock_relation)
      mock_relation.should_receive(:order).with('date DESC').and_return(mock_relation)

      get :show, id: asset.to_param

      response.should render_template :show
      assigns(:asset).should == asset
      assigns(:snapshots).should == mock_relation
      assigns(:contributions).should == mock_relation
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'assigns a new asset as @asset' do
        controller.login

        get :new

        response.should render_template :new
        assigns(:asset).should be_a_new FinancialAsset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :new

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'POST create' do
    context 'when logged in' do
      before do
        controller.login
      end

      describe 'with valid params' do
        it 'creates a new asset and redirects to the assets list' do
          FinancialAsset.any_instance.should_receive(:save).and_return(true)

          post :create, financial_asset: {}

          response.should redirect_to financial_assets_path
          flash[:success].should match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          FinancialAsset.any_instance.should_receive(:save).and_return(false)

          post :create, financial_asset: {}

          response.should render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, financial_asset: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'assigns the requested asset as @asset' do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)

        get :edit, id: @asset.to_param

        response.should render_template :edit
        assigns(:asset).should == @asset
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @asset.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      before do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
      end

      describe 'with valid params' do
        it 'redirects to the asset' do
          @asset.should_receive(:update_attributes).and_return(true)

          put :update, id: @asset.to_param, financial_asset: {}

          response.should redirect_to @asset
          flash[:success].should match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          @asset.should_receive(:update_attributes).and_return(false)

          put :update, id: @asset.to_param, financial_asset: {}

          response.should render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @asset.to_param, financial_asset: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @asset = stub_asset(permalink: 'bank')
    end

    context 'when logged in' do
      it 'destroys the requested asset and redirects to the assets list' do
        controller.login
        FinancialAsset.should_receive(:find_by_permalink).and_return(@asset)
        @asset.should_receive(:destroy).and_return(true)

        delete :destroy, id: @asset.to_param

        response.should redirect_to financial_assets_path
        flash[:success].should match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @asset.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end
end
