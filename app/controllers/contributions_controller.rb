class ContributionsController < ApplicationController
  before_action :authorize, only: [:new, :create, :edit, :update, :destroy]

  before_action :get_asset, only: [:new, :create]
  before_action :get_contribution, only: [:show, :edit, :update, :destroy]

  def index
    @contributions = Contribution.includes(:asset).order('date DESC')
  end

  def show
  end

  def new
    @contribution = @asset.contributions.build
  end

  def create
    @contribution = @asset.contributions.build contribution_params

    if @contribution.save
      flash[:success] = 'Contribution was successfully created.'
      redirect_to @asset
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @contribution.update_attributes contribution_params
      flash[:success] = 'Contribution was successfully updated.'
      redirect_to @contribution
    else
      render :edit
    end
  end

  def destroy
    @contribution.destroy

    flash[:success] = 'Contribution was successfully deleted.'
    redirect_to @asset
  end

  private

  def contribution_params
    params.fetch(:contribution).permit(:amount, :employer, :date, :permalink)
  end

  def get_asset
    @asset = FinancialAsset.find_by_permalink params[:financial_asset_id]
  end

  def get_contribution
    @contribution = Contribution.find_by_permalink params[:id]
    @asset = @contribution.asset
  end
end
