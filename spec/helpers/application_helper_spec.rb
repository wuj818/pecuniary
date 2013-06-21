require 'spec_helper'

describe ApplicationHelper do
  describe 'currency(number)' do
    it 'returns a comma delimited dollar amount' do
      helper.currency(1).should == '$1'
      helper.currency(1000).should == '$1,000'
      helper.currency(-1000).should == '-$1,000'
    end
  end
end
