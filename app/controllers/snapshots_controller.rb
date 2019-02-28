class SnapshotsController < ApplicationController
  before_action :authorize, only: %i[new create edit update destroy]

  before_action :set_asset, only: %i[new create]
  before_action :set_snapshot, only: %i[show edit update destroy]

  def show; end

  def new
    @snapshot = @asset.snapshots.build
  end

  def create
    @snapshot = @asset.snapshots.build snapshot_params

    if @snapshot.save
      flash[:success] = 'Snapshot was successfully created.'
      redirect_to @asset
    else
      render :new
    end
  end

  def edit; end

  def update
    if @snapshot.update snapshot_params
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

  def snapshot_params
    params.require(:snapshot).permit :date, :permalink, :value
  end

  def set_asset
    @asset = FinancialAsset.find_by! permalink: params[:financial_asset_id]
  end

  def set_snapshot
    @snapshot = Snapshot.find_by! permalink: params[:id]
    @asset = @snapshot.asset
  end
end
