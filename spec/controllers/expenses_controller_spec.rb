require 'spec_helper'

describe ExpensesController do
  describe 'GET index' do
    it 'assigns all monthly expenses as @monthly_expenses and all yearly expenses as @yearly_expenses' do
      Expense.should_receive(:monthly).and_return(mock_relation)
      Expense.should_receive(:yearly).and_return(mock_relation)

      get :index

      response.should render_template :index
      assigns(:monthly_expenses).should == mock_relation
      assigns(:yearly_expenses).should == mock_relation
    end
  end

  describe 'GET show' do
    it 'assigns the requested expense as @expense' do
      expense = stub_expense(permalink: 'rent')
      Expense.should_receive(:find_by_permalink).and_return(stub_expense)

      get :show, id: expense.to_param

      response.should render_template :show
      assigns(:expense).should == expense
    end
  end

  describe 'GET new' do
    context 'when logged in' do
      it 'assigns a new expense as @expense' do
        controller.login

        get :new

        response.should render_template :new
        assigns(:expense).should be_a_new Expense
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
        it 'creates a new expense and redirects to the expenses list' do
          Expense.any_instance.should_receive(:save).and_return(true)

          post :create, expense: {}

          response.should redirect_to expenses_path
          flash[:success].should match /created/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'new' template" do
          Expense.any_instance.should_receive(:save).and_return(false)

          post :create, expense: {}

          response.should render_template :new
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        post :create, expense: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'GET edit' do
    before do
      @expense = stub_expense(permalink: 'rent')
    end

    context 'when logged in' do
      it 'assigns the requested expense as @expense' do
        controller.login
        Expense.should_receive(:find_by_permalink).and_return(@expense)

        get :edit, id: @expense.to_param

        response.should render_template :edit
        assigns(:expense).should == @expense
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        get :edit, id: @expense.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'PUT update' do
    before do
      @expense = stub_expense(permalink: 'rent')
    end

    context 'when logged in' do
      before do
        controller.login
        Expense.should_receive(:find_by_permalink).and_return(@expense)
      end

      describe 'with valid params' do
        it 'redirects to the expense' do
          @expense.should_receive(:update_attributes).and_return(true)

          put :update, id: @expense.to_param, expense: {}

          response.should redirect_to @expense
          flash[:success].should match /updated/i
        end
      end

      describe 'with invalid params' do
        it "renders the 'edit' template" do
          @expense.should_receive(:update_attributes).and_return(false)

          put :update, id: @expense.to_param, expense: {}

          response.should render_template :edit
        end
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        put :update, id: @expense.to_param, expense: {}

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @expense = stub_expense(permalink: 'rent')
    end

    context 'when logged in' do
      it 'destroys the requested expense and redirects to the expenses list' do
        controller.login
        Expense.should_receive(:find_by_permalink).and_return(@expense)
        @expense.should_receive(:destroy).and_return(true)

        delete :destroy, id: @expense.to_param

        response.should redirect_to expenses_path
        flash[:success].should match /deleted/i
      end
    end

    context 'when logged out' do
      it 'redirects to the login page' do
        delete :destroy, id: @expense.to_param

        response.should redirect_to login_path
        flash[:warning].should match /must be logged in/i
      end
    end
  end
end
