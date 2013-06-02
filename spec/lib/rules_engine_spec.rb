require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }
  let(:rules) { rules_engine.instance_variable_get('@rules') }
  let(:preview) { '{"name":"Biking","category":"Fitness","objective":"Butterlap","time":5400,"experience":"Felt engaged","reps":null,"friends":[{"name":"Scott Levy","fb_id":"ScottBLevy"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Mary Ann Jawili","fb_id":"mjawili"}]}' }
  
  describe "#execute" do
    before(:each) do
      rules_engine.execute
    end
    context "#preview" do
      specify { rules_engine.preview.should == preview }
    end
  end
  
  describe "#save" do
    before(:each) do
      rules_engine.execute
      rules_engine.save
    end
    context "rules executed" do
      specify { rules.select { |rule| rule.cnt == 1 }.length.should == rules.length - 1 }
      specify { rules.select { |rule| rule.updated_at > rule.created_at }.length.should == rules.length - 1 }
    end
    context "rules that didn't execute" do
      specify { rules.select { |rule| rule.cnt == 0 }.length.should == 1 }
      specify { rules.select { |rule| rule.updated_at == rule.created_at }.length.should == 1 }
    end
  end
end
