class AssetSnapshotsController < ApplicationController
  before_filter :authorize, only: [:new, :create, :edit, :update, :destroy]

  before_filter :get_asset, only: [:new, :create]
  before_filter :get_snapshot, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @snapshot = @asset.snapshots.build
  end

  def create
    @snapshot = @asset.snapshots.build params[:asset_snapshot]

    if @snapshot.save
      flash[:success] = 'Snapshot was successfully created.'
      redirect_to @asset
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @snapshot.update_attributes params[:asset_snapshot]
      flash[:success] = 'Snapshot was successfully updated.'
      redirect_to @snapshot
    else
      render :edit
    end
  end

  def destroy
    @snapshot.destroy

    flash[:success] = 'Snapshot was successfully deleted.'
    redirect_to @asset
  end

  private

  def get_asset
    @asset = FinancialAsset.find_by_permalink params[:financial_asset_id]
  end

  def get_snapshot
    @snapshot = AssetSnapshot.find_by_permalink params[:id]
    @asset = @snapshot.asset
  end
end
