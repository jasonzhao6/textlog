require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:message) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  subject { RulesEngine.new(Message.create(message: message)) }
  its(:preview_activity) { should == '{"name":"Biking","category":"Fitness","objective":"Butterlap","time":5400,"experience":"Felt engaged","reps":null,"friends":[{"name":"Scott Levy","fb_id":"ScottBLevy"},{"name":"Alan Fineberg","fb_id":"fineberg"},{"name":"Mary Ann Jawili","fb_id":"mjawili"}]}' }
end
