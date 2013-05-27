require './lib/rules_engine'
require 'spec_helper'

describe RulesEngine do
  let(:body) { 'Biked Butterlap with Scott, Alan, Mary Ann. 1 hr 30 min. Felt engaged.' }
  let(:message) { Message.create(body: body) }
  subject { rules_engine = RulesEngine.new(message) }
  
  it { should be }
end
