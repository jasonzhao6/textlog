require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }

  before(:all) do
    load "#{Rails.root}/db/seeds.rb"
  end

  describe "#execute" do
    let(:retval) { rules_engine.execute }
    
    let(:activity) { retval[0] }
    let(:activity_to_json) { '{"primary_type":"Biking","secondary_type":"Butter Lap","duration":5400,"note":"Felt engaged","reps":null,"distance":17.4,"friends":[{"name":"Mary Ann Jawili","fb_id":"mjawili"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Scott Levy","fb_id":"ScottBLevy"}]}' }
    specify { activity.to_json.should == activity_to_json }

    context "when all but one rule applies" do
      let(:applicable_matchers) { retval[1] }
      let(:matcher_count) { Rule.matchers.count }
      specify { applicable_matchers.length.should == matcher_count - 1 }
    end
  end
  
  describe "#save" do
    context "before save" do
      before(:each) do
        rules_engine.execute
      end
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
      
      context "when rules' execution count should have been incremented" do
        specify { Rule.where(cnt: 0).count.should == 1 }
        specify { Rule.where('updated_at = created_at').count.should == 1 }
        specify { Rule.where(cnt: 1).count.should == Rule.count - 1 }
        specify { Rule.where('updated_at > created_at').count.should == Rule.count - 1 }
      end
    end
  end
end
