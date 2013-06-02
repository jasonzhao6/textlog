require 'spec_helper'

describe MessagesController do
  describe ".create" do
    context "when Twillio forwards a message" do
      let(:message) { 'Hello' }
      let(:params) { { 'AccountSid' => 'sid',
                       'Body' => message,
                       'ToZip' => 'zip',
                       'FromState' => 'state',
                       'ToCity' => 'city',
                       'SmsSid' => 'sid',
                       'ToState' => 'state',
                       'To' => '+number',
                       'ToCountry' => 'country',
                       'FromCountry' => 'country',
                       'SmsMessageSid' => 'sid',
                       'ApiVersion' => 'version',
                       'FromCity' => 'city',
                       'SmsStatus' => 'status',
                       'From' => '+number',
                       'FromZip' => 'zip' } }
                     
      before(:each) do
        controller.set_current_user
        post :create, params
      end
      
      specify { Message.count.should == 1 }
      specify { Message.first.message.should == message }
    end
  end
end
