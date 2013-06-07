require 'spec_helper'

describe Activity do
  describe "COMMANDS" do
    let(:activity) { Activity.new }
    subject { activity }
    
    # Testing just one command
    context "when arg is a hash string" do
      describe "#set_primary_type" do
        let(:hsh) { "{ 'primary_type' => 'biking' }" }
        before(:each) do
          activity.set_primary_type(hsh)
        end
        its(:primary_type) { should == 'Biking' }
      end
    end
    
    # Testing all commands
    context "when arg is a hash" do
      describe "#set_primary_type" do
        let(:hsh) { { 'primary_type' => 'biking' } }
        before(:each) do
          activity.set_primary_type(hsh)
        end
        its(:primary_type) { should == 'Biking' }
      end

      describe "#set_secondary_type" do
        let(:hsh) { { 'secondary_type' => 'marin headlands' } }
        before(:each) do
          activity.set_secondary_type(hsh)
        end
        its(:secondary_type) { should == 'Marin Headlands' }
      end

      describe "#add_friend" do
        let(:name) { 'James Bond' }
        let(:fb_id) { '###' }
        let(:hsh) { { name: name, fb_id: fb_id } }
        before(:each) do
          activity.add_friend(hsh)
        end
        its('friends.length') { should == 1 }
        its('friends.first.name') { should == name }
        its('friends.first.fb_id') { should == fb_id }
        specify { Company.count.should == 0 }
        specify { Friend.count.should == 0 }

        context "when adding the same friend again" do
          let(:name2) { 'James Bond' }
          let(:fb_id2) { '###' }
          let(:hsh2) { { name: name2, fb_id: fb_id2 } }
          before(:each) do
            activity.add_friend(hsh2)
          end
          its('friends.length') { should == 1 }
          its('friends.first.name') { should == name }
          its('friends.first.fb_id') { should == fb_id }
          specify { Company.count.should == 0 }
          specify { Friend.count.should == 0 }

          context "after save" do
            before(:each) do
              activity.save
            end
            specify { Company.count.should == 1 }
            specify { Friend.count.should == 1 }
          end
        end

        context "when adding a different friend" do
          let(:name3) { 'King Kong' }
          let(:fb_id3) { '%%%' }
          let(:hsh3) { { name: name3, fb_id: fb_id3 } }
          before(:each) do
            activity.add_friend(hsh3)
          end
          its('friends.length') { should == 2 }
          its('friends.last.name') { should == name3 }
          its('friends.last.fb_id') { should == fb_id3 }
          specify { Company.count.should == 0 }
          specify { Friend.count.should == 0 }

          context "after save" do
            before(:each) do
              activity.save
            end
            specify { Company.count.should == 2 }
            specify { Friend.count.should == 2 }
          end
        end
      end

      describe "#add_duration" do
        let(:num) { '1' }
        let(:unit) { 'min' }
        let(:hsh) { { 'num' => num, 'unit' => unit } }
        before(:each) do
          activity.add_duration(hsh)
        end
        its(:duration) { should == 60 }

        context "when adding additional duration" do
          let(:num2) { '2' }
          let(:unit2) { 'hr' }
          let(:hsh2) { { 'num' => num2, 'unit' => unit2 } }
          before(:each) do
            activity.add_duration(hsh2)
          end
          its(:duration) { should == 7260 }
        end
      end

      describe "#set_distance" do
        context "when adding 5k" do
          let(:num) { '5' }
          let(:unit) { 'k' }
          let(:hsh) { { 'num' => num, 'unit' => unit } }
          before(:each) do
            activity.set_distance(hsh)
          end
          its(:distance) { should == 3.106855 }
        end
        context "when adding 17.4 mi" do
          let(:num) { '17.4' }
          let(:unit) { 'mi' }
          let(:hsh) { { 'num' => num, 'unit' => unit } }
          before(:each) do
            activity.set_distance(hsh)
          end
          its(:distance) { should == 17.4 }
        end
      end

      describe "#set_reps" do
        let(:hsh) { { 'reps' => '10' } }
        before(:each) do
          activity.set_reps(hsh)
        end
        its(:reps) { should == 10 }
      end

      describe "#set_note" do
        let(:hsh) { { 'note' => 'felt engaged' } }
        before(:each) do
          activity.set_note(hsh)
        end
        its(:note) { should == 'Felt engaged' }
      end
    end
  end
end
