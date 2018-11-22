require 'rails_helper'

RSpec.describe Milestone do
  describe 'callbacks' do
    let(:date) { Date.new 2010, 7, 28 }
    let(:milestone) { create :milestone, date: date }

    it 'sets the date to the current day by default' do
      Timecop.freeze
      milestone = Milestone.new
      expect(milestone.date).to eq Time.zone.now.to_date
    end

    it 'creates a permalink from the date' do
      expect(milestone.permalink).to eq 'july-28-2010'
    end
  end

  describe 'instance methods' do
    describe 'to_param' do
      it "doesn't change until after the record is saved" do
        milestone = create :milestone, date: Date.new(2010, 7, 28)
        old_to_param = milestone.to_param

        milestone.permalink = 'test'
        expect(milestone.to_param).to eq old_to_param

        milestone.date = Date.new 2011, 3, 28
        milestone.save
        expect(milestone.to_param).not_to eq old_to_param
      end
    end
  end

  describe 'validations' do
    it 'has required attributes' do
      milestone = Milestone.create

      [:notes].each do |attribute|
        expect(milestone.errors[attribute]).to include "can't be blank"
      end
    end

    it 'requires a unique date' do
      milestone1 = create :milestone
      milestone2 = build :milestone, date: milestone1.date
      milestone2.save

      expect(milestone2.errors[:date]).to include 'has already been taken'
    end
  end
end
