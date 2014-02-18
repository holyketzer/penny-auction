require 'spec_helper'

describe ApplicationHelper do
  describe '.timespan_to_s' do
    it 'for 25 seconds' do 
      expect(helper.timespan_to_s(25)).to eq('00:00:25') 
    end

    it 'for 13 minutes 53 seconds' do 
      delta = 13*60 + 53
      expect(helper.timespan_to_s(delta)).to eq('00:13:53')
    end

    it 'for 27 hours 5 minutes 1 second' do
      delta = 27*3600 + 5*60 + 1
      expect(helper.timespan_to_s(delta)).to eq('27:05:01')
    end
  end  
end