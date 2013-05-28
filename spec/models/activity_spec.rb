require 'spec_helper'

describe Activity do
  describe "COMMANDS" do
    let(:activity) { Activity.new }
    subject { activity }
    
    describe "#set_name" do
      let(:str) { 'biking' }
      before(:each) do
        activity.set_name(str)
      end
      its(:name) { should == 'Biking' }
    end
    
    describe "#set_category" do
      let(:str) { 'Workout' }
      before(:each) do
        activity.set_category(str)
      end
      its(:category) { should == 'Workout' }
    end
    
    describe "#set_objective" do
      let(:hsh) { {'objective' => 'Butterlap '} }
      before(:each) do
        activity.set_objective(hsh)
      end
      its(:objective) { should == 'Butterlap' }
    end
    
    describe "#set_mood" do
      let(:str) { 'excited' }
      before(:each) do
        activity.set_mood(str)
      end
      its(:mood) { should == 'Excited!' }
    end
    
    describe "#add_friend" do
      let(:name) { 'James Bond' }
      let(:fb_id) { '###' }
      before(:each) do
        activity.add_friend(name, fb_id)
      end
      its('friends.length') { should == 1 }
      its('friends.first.name') { should == name }
      its('friends.first.fb_id') { should == fb_id }
      
      context "when adding the same friend again" do
        let(:name2) { 'James Bond' }
        let(:fb_id2) { '###' }
        before(:each) do
          activity.add_friend(name2, fb_id2)
        end
        its('friends.length') { should == 1 }
        its('friends.first.name') { should == name }
        its('friends.first.fb_id') { should == fb_id }
      end
      
      context "when adding a different friend" do
        let(:name3) { 'King Kong' }
        let(:fb_id3) { '%%%' }
        before(:each) do
          activity.add_friend(name3, fb_id3)
        end
        its('friends.length') { should == 2 }
        its('friends.last.name') { should == name3 }
        its('friends.last.fb_id') { should == fb_id3 }
      end
    end
    
    describe "#add_time" do
      let(:num) { '1' }
      let(:unit) { 'minute' }
      before(:each) do
        activity.add_time(num, unit)
      end
      its(:time) { should == 60 }
      
      context "when adding additional time" do
        let(:num2) { '2' }
        let(:unit2) { 'hour' }
        before(:each) do
          activity.add_time(num2, unit2)
        end
        its(:time) { should == 7260 }
      end
    end
  end
end
