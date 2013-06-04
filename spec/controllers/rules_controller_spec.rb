require 'spec_helper'

describe RulesController do
  describe ".create" do
    context "when there is one matcher and two setters" do
      let(:matcher_command) { 'match' }
      let(:matcher_arg) { '[regex]' }
      let(:setter_command) { 'set_name' }
      let(:setter_arg) { 'name' }
      let(:setter2_command) { 'set_category' }
      let(:setter2_arg) { 'category' }
      let(:params) { { rule: { command:  matcher_command,
                               arg:      matcher_arg,
                               commands: [ setter_command,
                                           setter2_command ],
                               args:     [ setter_arg,
                                           setter2_arg ] } } }
      let(:json) { '[{"command":"set_name","arg":"name","cnt":0},{"command":"set_category","arg":"category","cnt":0},{"command":"match","arg":"[regex]","cnt":0}]' }
                       
      before(:each) do
        Rule.delete_all
        controller.set_current_user
        post :create, params
      end
      
      subject { Rule.all }
      its(:count) { should == 3 }
      its(:to_json) { should == json }
    end
  end
end
