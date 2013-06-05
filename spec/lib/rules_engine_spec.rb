require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }
  let(:activity) { rules_engine.instance_variable_get('@activity') }
  let(:activity_to_json) { '{"name":"Biking","category":"Fitness","objective":"Butterlap","time":5400,"experience":"Felt engaged","reps":null,"friends":[{"name":"Mary Ann Jawili","fb_id":"mjawili"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Scott Levy","fb_id":"ScottBLevy"}]}' }
  let(:matchers) { rules_engine.instance_variable_get('@rules') }
  let(:rules) { Rule.all }
  
  before(:all) do
    load "#{Rails.root}/db/seeds.rb"
  end
  
  describe "#execute" do
    before(:each) do
      rules_engine.execute
    end
    specify { activity.to_json.should == activity_to_json }
    
    describe "#save" do
      context "only one rule will not be executed" do
        context "before save" do
          specify { Rule.where(cnt: 0).count.should == rules.length }
          specify { Rule.where('updated_at = created_at').count.should == rules.length }
        end
    
        context "after save" do
          before(:each) do
            rules_engine.save
          end
          specify { Rule.where(cnt: 0).count.should == 1 }
          specify { Rule.where('updated_at = created_at').count.should == 1 }
          specify { Rule.where(cnt: 1).count.should == rules.length - 1 }
          specify { Rule.where('updated_at > created_at').count.should == rules.length - 1 }
        end
      end
    end
  end
end
