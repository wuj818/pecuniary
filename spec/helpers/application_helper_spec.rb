require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe 'currency(number)' do
    it 'returns a comma delimited dollar amount' do
      expect(helper.currency(1)).to eq '$1'
      expect(helper.currency(1000)).to eq '$1,000'
      expect(helper.currency(-1000)).to eq '-$1,000'
    end
  end
end
