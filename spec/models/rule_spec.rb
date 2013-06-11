require 'spec_helper'

describe Rule do
  describe "before_filters" do
    describe "#set_cnt_was_last_updated" do
      subject { Rule.create(command: 'add_duration') }
      context "cnt was last updated" do
        before(:each) do
          subject.update_attributes(command: 'add_friend')
        end
        its(:cnt_was_last_updated?) { should_not be }
      end
      context "cnt was not last updated" do
        before(:each) do
          subject.update_attributes(cnt: 1)
        end
        its(:cnt_was_last_updated?) { should be }
      end
    end
  end
end
