require 'spec_helper'

describe RulesHelper do
  describe "Attribute helpers" do
    describe "#matcher_arg" do
      context "when matcher arg has no named variable" do
        let(:arg_before) { 'ignore' }
        let(:arg_after) { 'ignore' }
        let(:matcher) { Rule.create(command: 'match', arg: arg_before) }
        specify { helper.matcher_arg(matcher.arg).should == arg_after }
      end
      
      context "when matcher arg has one named variable" do
        let(:arg_before) { '(?<note>felt.*)\.' }
        let(:arg_after) { '(?&lt;<em>note</em>&gt;felt.*)\.' }
        let(:matcher) { Rule.create(command: 'match', arg: arg_before) }
        specify { helper.matcher_arg(matcher.arg).should == arg_after }
      end
      
      context "when matcher arg has three named variables" do
        let(:arg_before) { '(?<duration>\d+) ?(?<unit>hr)' }
        let(:arg_after) { '(?&lt;<em>duration</em>&gt;\d+) ?(?&lt;<em>unit</em>&gt;hr)' }
        let(:matcher) { Rule.create(command: 'match', arg: arg_before) }
        specify { helper.matcher_arg(matcher.arg).should == arg_after }
      end
    end

    describe "#setter_arg" do
      context "when setter arg is present" do
        let(:arg_before) { 'ignore' }
        let(:arg_after) { 'ignore' }
        let(:matcher) { Rule.create(command: 'match') }
        let(:setter) { Rule.new(command: 'set_reps',
                                arg: arg_before,
                                matcher_id: matcher.id) }
        specify { helper.setter_arg(setter.arg, matcher.arg).should == arg_after }
      end

      context "when setter arg is blank" do
        context "when matcher arg has no named variable" do
          let(:arg_before) { }
          let(:arg_after) { '{  }' }
          let(:matcher) { Rule.create(command: 'match', arg: '.*') }
          let(:setter) { Rule.new(command: 'set_reps',
                                  matcher_id: matcher.id) }
          specify { helper.setter_arg(setter.arg, matcher.arg).should == arg_after }
        end

        context "when matcher arg has one named variable" do
          let(:arg_before) { '(?<anything>.*)' }
          let(:arg_after) { '{ anything: <<em>anything</em>> }' }
          let(:matcher) { Rule.create(command: 'match', arg: arg_before) }
          let(:setter) { Rule.new(command: 'set_reps',
                                  matcher_id: matcher.id) }
          specify { helper.setter_arg(setter.arg, matcher.arg).should == arg_after }
        end

        context "when matcher arg has three named variables" do
          let(:arg_before) { '(?<one>.*)-(?<two>.*)-(?<three>.*))' }
          let(:arg_after) { '{ one: <<em>one</em>>, two: <<em>two</em>>, three: <<em>three</em>> }' }
          let(:matcher) { Rule.create(command: 'match',
                                      arg: arg_before) }
          let(:setter) { Rule.new(command: 'set_reps',
                                  matcher_id: matcher.id) }
          specify { helper.setter_arg(setter.arg, matcher.arg).should == arg_after }
        end
      end
    end
  end
end
