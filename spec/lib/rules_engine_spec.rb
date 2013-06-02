require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:text) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(message: text) }
  let(:rules_engine) { RulesEngine.new(message) }
  it "should parse message correctly" do
    rules_engine.preview_activity.should == '{"name":"Biking","category":"Fitness","objective":"Butterlap","time":5400,"experience":"Felt engaged","reps":null,"friends":[{"name":"Scott Levy","fb_id":"ScottBLevy"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Mary Ann Jawili","fb_id":"mjawili"}]}'
  end
  
  let(:rules) { rules_engine.instance_variable_get('@rules') }
  it "should update rules updated_at timestamp" do
    rules.each do |rule|
      rule.updated_at.should > rule.created_at
    end
  end
end
