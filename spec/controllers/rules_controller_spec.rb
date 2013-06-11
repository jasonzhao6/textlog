require 'spec_helper'

describe RulesController do
  describe "#create" do
    context "when there is one matcher and two setters" do
      let(:matcher_command) { 'match' }
      let(:matcher_arg) { '[regex]' }
      let(:setter_command) { 'set_primary_type' }
      let(:setter_arg) { 'biking' }
      let(:setter2_command) { 'set_secondary_type' }
      let(:setter2_arg) { 'marin headlands' }
      let(:params) { { rule: { command:  matcher_command,
                               arg:      matcher_arg },
                       commands: [ setter_command,
                                   setter2_command ],
                       args:     [ setter_arg,
                                   setter2_arg ] } }
      let(:rule_to_json) { '[{"command":"match","arg":"[regex]","cnt":0,"cnt_was_last_updated":false},{"command":"set_primary_type","arg":"biking","cnt":0,"cnt_was_last_updated":false,"matcher":{"matcher_id":null,"command":"match","arg":"[regex]","cnt":0,"cnt_was_last_updated":false}},{"command":"set_secondary_type","arg":"marin headlands","cnt":0,"cnt_was_last_updated":false,"matcher":{"matcher_id":null,"command":"match","arg":"[regex]","cnt":0,"cnt_was_last_updated":false}}]' }
                       
      before(:each) do
        Rule.delete_all
        controller.set_current_user
        post :create, params
      end
      
      subject { Rule.all }
      its(:count) { should == 3 }
      its(:to_json) { should == rule_to_json }
    
      describe "#update" do
        context "when updating matcher arg and deleting 2nd setter" do
          let(:matcher) { Rule.matchers.first }
          let(:matcher_arg2) { '[regex2]' }
          let(:update_params) { { id: matcher.id,
                                  rule: { command:  matcher_command,
                                          arg:      matcher_arg2 },
                                  commands: [ setter_command ],
                                  args:     [ setter_arg ] } }
          let(:rule_to_json_updated) { '[{"command":"match","arg":"[regex2]","cnt":0,"cnt_was_last_updated":false},{"command":"set_primary_type","arg":"biking","cnt":0,"cnt_was_last_updated":false,"matcher":{"matcher_id":null,"command":"match","arg":"[regex2]","cnt":0,"cnt_was_last_updated":false}}]' }
         
         before(:each) do
           put :update, update_params
         end
         
         subject { Rule.all }
         its(:count) { should == 2 }
         its(:to_json) { should == rule_to_json_updated }
        end
      end
    end
  end
end
