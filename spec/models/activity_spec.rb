require 'spec_helper'

describe Activity do
  describe "presenters" do
    describe ".top_activities" do
      let(:retval) { [["Biking", "4"], ["Crossfit", "1"]] }
      before(:each) do
        4.times { Fabricate(:activity, activity: 'Biking') }
        1.times { Fabricate(:activity, activity: 'Crossfit') }
      end
      specify { Activity.top_activities.should == retval }
    end
  end
  
  describe "COMMANDS" do
    subject { Fabricate.build(:activity) }
    
    # ['set_activity', 'add_friend'] should support this, testing all
    context "when arg is a string" do
      describe "#set_activity" do
        let(:str) { 'biking' }
        before(:each) do
          subject.set_activity(str)
        end
        its(:activity) { should == 'Biking' }
      end

      describe "#add_friend" do
        let(:friend) { Fabricate.build(:friend) }
        let(:friend_str) { "#{friend.name},#{friend.fb_id}" }
        let(:friend2) { Fabricate.build(:friend) }
        let(:friend2_str) { "#{friend2.name}, #{friend2.fb_id}" }
        before(:each) do
          subject.add_friend(friend_str)
          subject.add_friend(friend2_str)
        end
        its('friends.length') { should == 2 }
        its('friends.first.name') { should == friend.name }
        its('friends.first.fb_id') { should == friend.fb_id }
        its('friends.last.name') { should == friend2.name }
        its('friends.last.fb_id') { should == friend2.fb_id }
      end
    end
    
    # All commands should support this, testing one
    context "when arg is a hash string" do
      describe "#set_activity" do
        let(:str) { "{ activity: 'biking' }" }
        before(:each) do
          subject.set_activity(str)
        end
        its(:activity) { should == 'Biking' }
      end
    end
    
    # All commands should support this, testing all
    context "when arg is a hash" do
      describe "#set_activity" do
        let(:hsh) { { activity: 'biking' } }
        before(:each) do
          subject.set_activity(hsh)
        end
        its(:activity) { should == 'Biking' }
      end

      describe "#add_friend" do
        let(:friend) { Fabricate.build(:friend) }
        let(:friend_hsh) { { name: friend.name, fb_id: friend.fb_id } }
        let(:friend2) { Fabricate.build(:friend) }
        let(:friend2_hsh) { { name: friend2.name, fb_id: friend2.fb_id } }
        before(:each) do
          subject.add_friend(friend_hsh)
        end
        its('friends.length') { should == 1 }
        its('friends.first.name') { should == friend.name }
        its('friends.first.fb_id') { should == friend.fb_id }
        specify { Company.count.should == 0 }
        specify { Friend.count.should == 0 }

        context "when adding the same friend again" do
          before(:each) do
            subject.add_friend(friend_hsh)
          end
          its('friends.length') { should == 1 }
          its('friends.first.name') { should == friend.name }
          its('friends.first.fb_id') { should == friend.fb_id }
          specify { Company.count.should == 0 }
          specify { Friend.count.should == 0 }

          context "after save" do
            before(:each) do
              subject.save
            end
            specify { Company.count.should == 1 }
            specify { Friend.count.should == 1 }
          end
        end

        context "when adding a different friend" do
          before(:each) do
            subject.add_friend(friend2_hsh)
          end
          its('friends.length') { should == 2 }
          its('friends.last.name') { should == friend2.name }
          its('friends.last.fb_id') { should == friend2.fb_id }
          specify { Company.count.should == 0 }
          specify { Friend.count.should == 0 }

          context "after save" do
            before(:each) do
              subject.save
            end
            specify { Company.count.should == 2 }
            specify { Friend.count.should == 2 }
          end
        end
      end

      describe "#add_duration" do
        let(:num) { '1' }
        let(:unit) { 'min' }
        let(:hsh) { { num: num, unit: unit } }
        before(:each) do
          subject.add_duration(hsh)
        end
        its(:duration) { should == 60 }

        context "when adding additional duration" do
          let(:num2) { '2' }
          let(:unit2) { 'hr' }
          let(:hsh2) { { num: num2, unit: unit2 } }
          before(:each) do
            subject.add_duration(hsh2)
          end
          its(:duration) { should == 7260 }
        end
      end

      describe "#set_distance" do
        context "when adding 5k" do
          let(:num) { '5' }
          let(:unit) { 'k' }
          let(:hsh) { { num: num, unit: unit } }
          before(:each) do
            subject.set_distance(hsh)
          end
          its(:distance) { should == 3.106855 }
        end
        context "when adding 17.4 mi" do
          let(:num) { '17.4' }
          let(:unit) { 'mi' }
          let(:hsh) { { num: num, unit: unit } }
          before(:each) do
            subject.set_distance(hsh)
          end
          its(:distance) { should == 17.4 }
        end
      end

      describe "#set_reps" do
        let(:hsh) { { reps: '10' } }
        before(:each) do
          subject.set_reps(hsh)
        end
        its(:reps) { should == 10 }
      end

      describe "#set_note" do
        context "when note is all lower case" do
          let(:hsh) { { note: 'felt engaged' } }
          before(:each) do
            subject.set_note(hsh)
          end
          its(:note) { should == 'Felt engaged' }
        end
        context "when note is all caps" do
          let(:hsh) { { note: 'SCCA' } }
          before(:each) do
            subject.set_note(hsh)
          end
          its(:note) { should == 'SCCA' }
        end
      end
    end
  end
end
