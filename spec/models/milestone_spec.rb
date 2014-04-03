require 'spec_helper'

describe Milestone do
  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:milestone) { Milestone.make! date: date }

    it 'sets the date to the current day by default' do
      Timecop.freeze
      milestone = Milestone.new
      milestone.date.should == Time.zone.now.to_date
    end

    it 'creates a permalink from the date' do
      milestone.permalink.should == 'july-28-2010'
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        milestone = Milestone.make! date: Date.new(2010, 7, 28)
        old_to_param = milestone.to_param

        milestone.permalink = 'test'
        milestone.to_param.should == old_to_param

        milestone.date = Date.new(2011, 3, 28)
        milestone.save
        milestone.to_param.should_not == old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      milestone = Milestone.create

      [:notes].each do |attribute|
        milestone.errors[attribute].should include "can't be blank"
      end
    end

    it 'requires a unique date' do
      milestone1 = Milestone.make!
      milestone2 = Milestone.make date: milestone1.date
      milestone2.save

      milestone2.errors[:date].should include 'has already been taken'
    end
  end
end
