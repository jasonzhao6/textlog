require 'spec_helper'

describe Message do
  describe "COMMANDS" do
    let(:message) { Message.new(body: 'Biked Butterlap') }
    
    describe "#match" do
      let(:pattern) { 'biked (?<objective>\w+)' }
      subject { message.match(pattern) }
      its(:class) { should == MatchData }
      its(:names) { should == ['objective'] }
      its(:captures) { should == ['Butterlap'] }
    end
  end
end
