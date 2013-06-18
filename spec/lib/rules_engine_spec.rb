require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }

  context "when all but 2 rules (1 matcher + 1 setter) execute successfully" do
    before(:all) do
      load "#{Rails.root}/db/seeds.rb"
    end

    describe "#execute" do
      let(:retval) { rules_engine.execute }
      let(:activity) { retval[0] }
      let(:applicable_matchers) { retval[1] }
      specify { activity.to_json.should == '{"activity":"Butterlap","duration":5400,"note":"Felt engaged","reps":null,"distance":17.4,"friends":[{"name":"Mary Ann Jawili","fb_id":"mjawili"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Scott Levy","fb_id":"ScottBLevy"}]}' }
      specify { activity.to_json.should_not =~ /Error/ }
      specify { applicable_matchers.length.should == Rule.matchers.count - 1 }
    end
  
    describe "#save" do
      context "before save" do
        before(:each) do
          rules_engine.execute
        end
        specify { Message.unparsed.count.should == 1 }
        specify { Activity.count.should == 0 }
        specify { Rule.where(cnt: 0).count.should == Rule.count }
        specify { Rule.where('updated_at = created_at').count.should == Rule.count }
      end
    
      context "after save" do
        before(:each) do
          rules_engine.execute
          rules_engine.save
        end
        specify { Message.unparsed.count.should == 0 }
        specify { Activity.count.should == 1 }
        specify { Activity.first.message.should == message }
        specify { Rule.where(cnt: 0).count.should == 2 }
        specify { Rule.where('updated_at = created_at').count.should == 2 }
        specify { Rule.where(cnt: 1).count.should == Rule.count - 2 }
        specify { Rule.where('updated_at > created_at').count.should == Rule.count - 2 }
      end
    end
  end
end
