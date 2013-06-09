require 'spec_helper'

describe ApplicationHelper do
  describe "#time_ago" do
    context "when 'about' is dropped" do
      let(:time) { Time.now - 15.hours }
      let(:with_about) { 'about 15 hours' }
      let(:without_about) { '15 hours' }
      specify { helper.time_ago_in_words(time).should == with_about }
      specify { helper.time_ago(time).should == without_about }
    end

    context "when 'less than' is dropped" do
      let(:time) { Time.now }
      let(:with_about) { 'less than a minute' }
      let(:without_about) { 'a minute' }
      specify { helper.time_ago_in_words(time).should == with_about }
      specify { helper.time_ago(time).should == without_about }
    end
  end
end
