# frozen_string_literal: true

class ContributionsController < ApplicationController
  before_action :authorize, only: %i[new create edit update destroy]

  before_action :set_asset, only: %i[new create]
  before_action :set_contribution, only: %i[show edit update destroy]

  def index
    @contributions = Contribution.includes(:asset).order("date DESC")
  end

  def show; end

  def new
    @contribution = @asset.contributions.build
  end

  def create
    @contribution = @asset.contributions.build contribution_params

    if @contribution.save
      flash[:success] = "Contribution was successfully created."
      redirect_to @asset
    else
      render :new
    end
  end

  def edit; end

  def update
    if @contribution.update contribution_params
      flash[:success] = "Contribution was successfully updated."
      redirect_to @contribution
    else
      render :edit
    end
  end

  def destroy
    @contribution.destroy

    flash[:success] = "Contribution was successfully deleted."
    redirect_to @asset
  end

  private

  def contribution_params
    params.require(:contribution).permit :amount, :employer, :date, :permalink
  end

  def set_asset
    @asset = FinancialAsset.find_by! permalink: params[:financial_asset_id]
  end

  def set_contribution
    @contribution = Contribution.find_by! permalink: params[:id]
    @asset = @contribution.asset
  end
end
