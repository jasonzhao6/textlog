require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }
  let(:activity_to_json) { '{"primary_type":"Biking","secondary_type":"Butter Lap","duration":5400,"note":"Felt engaged","reps":null,"distance":17.4,"friends":[{"name":"Mary Ann Jawili","fb_id":"mjawili"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Scott Levy","fb_id":"ScottBLevy"}]}' }
  let(:rules) { Rule.all }
  let(:matchers) { Rule.matchers }
  
  before(:all) do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  describe "#execute" do
    context "only one rule would not be executed" do
      let(:activity_rules) { rules_engine.execute }
      let(:activity) { activity_rules.first }
      let(:applicable_matchers) { activity_rules.last }
    
      specify { activity.to_json.should == activity_to_json }
      specify { applicable_matchers.length.should == matchers.length - 1 }
    
      describe "#save" do
        context "before save" do
          specify { Rule.where(cnt: 0).count.should == rules.length }
          specify { Rule.where('updated_at = created_at').count.should == rules.length }
        end
  
        context "after save" do
          before(:each) do
            rules_engine.execute
            rules_engine.save
          end
          specify { Message.unparsed.count.should == 0 }
          specify { Activity.count.should == 1 }
          specify { activity.message.should == message }
          specify { Rule.where(cnt: 0).count.should == 1 }
          specify { Rule.where('updated_at = created_at').count.should == 1 }
          specify { Rule.where(cnt: 1).count.should == rules.length - 1 }
          specify { Rule.where('updated_at > created_at').count.should == rules.length - 1 }
        end
      end
    end
  end
end
