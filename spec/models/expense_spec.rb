require 'spec_helper'

describe Expense do
  describe 'callbacks' do
    it 'creates a parameterized permalink' do
      expense = Expense.make! name: 'Rent'
      expense.permalink.should == 'rent'
    end
  end

  describe 'instance methods' do
    describe 'frequency_label' do
      it 'produces a readable version of the frequency' do
        expense = Expense.make! name: 'Rent', frequency: 12
        expense.frequency_label.should == 'Monthly'

        expense.frequency = 1
        expense.frequency_label.should == 'Yearly'
      end
    end

    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        expense = Expense.make! name: 'Rent'
        old_to_param = expense.to_param

        expense.permalink = 'test'
        expense.to_param.should == old_to_param

        expense.name = 'Food'
        expense.save
        expense.to_param.should_not == old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      expense = Expense.create

      [:name].each do |attribute|
        expense.errors[attribute].should include "can't be blank"
      end
    end

    it 'requires a unique name' do
      expense1 = Expense.make!
      expense2 = Expense.make name: expense1.name
      expense2.save

      expense2.errors[:name].should include 'has already been taken'
    end

    it 'requires a positive non-zero cost' do
      [-1, 0].each do |cost|
        expense = Expense.create cost: cost
        expense.errors[:cost].should include 'must be greater than 0'
      end
    end

    it 'requires a valid frequency' do
      [-1, 0, 8].each do |frequency|
        expense = Expense.create frequency: frequency
        expense.errors[:frequency].should include 'is not valid'
      end
    end
  end
end
