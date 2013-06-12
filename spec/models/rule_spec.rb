require 'spec_helper'

describe Rule do
  describe "before_filters" do
    describe "#set_cnt_was_last_updated" do
      subject { Rule.create(command: 'add_duration', arg: 'ignore') }
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
  
  describe "validations" do
    describe "#arg" do
      context "when rule is a matcher" do
        context "when arg is set" do
          subject { Rule.new(command: 'match', arg: 'ignore') }
          before(:each) do
            subject.valid?
          end
          its('errors.full_messages') { should == [] }
        end
        context "when arg is not set" do
          subject { Rule.new(command: 'match') }
          before(:each) do
            subject.valid?
          end
          its('errors.full_messages') { should == ["Arg can't be blank"] }
        end
      end
      
      context "when rule is a setter" do
        context "when arg is set" do
          subject { Rule.new(matcher_id: 1, command: 'set_reps', arg: '10') }
          before(:each) do
            subject.valid?
          end
          its('errors.full_messages') { should == [] }
        end
        context "when arg is not set" do
          subject { Rule.new(matcher_id: 1, command: 'set_reps') }
          before(:each) do
            subject.valid?
          end
          its('errors.full_messages') { should == [] }
        end
      end
    end
  end
end
