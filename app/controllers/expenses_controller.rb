class ExpensesController < ApplicationController
  before_filter :authorize, only: [:new, :create, :edit, :update, :destroy]

  before_filter :get_expense, only: [:show, :edit, :update, :destroy]

  def index
    @monthly_expenses = Expense.monthly.order(:name)
    @yearly_expenses = Expense.yearly.order(:name)
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(params[:expense])

    if @expense.save
      flash[:success] = 'Expense was successfully created.'
      redirect_to expenses_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @expense.update_attributes params[:expense]
      flash[:success] = 'Expense was successfully updated.'
      redirect_to @expense
    else
      render :edit
    end
  end

  def destroy
    @expense.destroy

    flash[:success] = 'Expense was successfully deleted.'
    redirect_to expenses_path
  end

  private

  def get_expense
    @expense = Expense.find_by_permalink params[:id]
  end
end
