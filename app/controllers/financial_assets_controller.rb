class FinancialAssetsController < ApplicationController
  before_action :authorize, only: [:new, :create, :edit, :update, :destroy]

  before_action :get_asset, only: [:show, :edit, :update, :destroy]

  def index
    @assets = FinancialAsset.includes(:snapshots).order(:name)
  end

  def show
    @snapshots = @asset.snapshots.order('date DESC')
    @contributions = @asset.investment? ? @asset.contributions.order('date DESC') : []
  end

  def new
    @asset = FinancialAsset.new
  end

  def create
    @asset = FinancialAsset.new asset_params

    if @asset.save
      flash[:success] = 'Asset was successfully created.'
      redirect_to financial_assets_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @asset.update asset_params
      flash[:success] = 'Asset was successfully updated.'
      redirect_to @asset
    else
      render :edit
    end
  end

  def destroy
    @asset.destroy

    flash[:success] = 'Asset was successfully deleted.'
    redirect_to financial_assets_path
  end

  private

  def asset_params
    params.fetch(:financial_asset).permit(:name, :investment)
  end

  def get_asset
    @asset = FinancialAsset.find_by_permalink params[:id]
  end
end
