# -*- coding: utf-8 -*-

require 'helper'

class TestFlattenFilter
  RSpec.describe Fluent::Plugin::FlattenFilter do

    CONFIG = %[]

    def create_driver(conf=CONFIG)
      Fluent::Test::Driver::Filter.new(Fluent::Plugin::FlattenFilter)
    end

    def create_filter
      Fluent::Plugin::FlattenFilter.new
    end

    before :all do
      Fluent::Test.setup
    end

    before :each do
      @text = "{'key'=>'value'}"
      @filter = create_filter
      @test_driver = create_driver
    end



    context "#flatten" do

      it "no error because of empty record" do
        expect(@filter.flatten({})).to eq Hash.new
      end

      it "no error with disabled" do
        @filter.enabled = false
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["key.dot"] = "value.dot"
        expect_hash = {}
        expect_hash["key"] = "value"
        expect_hash["key.dot"] = "value.dot"
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

      it "no error with non recursive hash" do
        @filter.recurse = false
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["key.dot"] = "value.dot"
        expect_hash = {}
        expect_hash["key"] = test_hash["key"]
        expect_hash["key_dot"] = test_hash["key.dot"]
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

      it "no error with recursive hash with de_dot_nested = false" do
        # "child_dot" => {"key"=>"value", "key.dot"=>"value.dot"}
        @filter.recurse = false
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["child.dot"] = test_child_hash
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key.dot"] = test_child_hash["key.dot"]
        expect_hash = {}
        expect_hash["key"] = "value"
        expect_hash["child_dot"] = expect_child_hash
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

      it "no error with recursive hash with de_dot_nested = true" do
        # "child_dot" => {"key"=>"value", "key_dot"=>"value.dot"}
        @filter.recurse = true
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["child.dot"] = test_child_hash
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key_dot"] = test_child_hash["key.dot"]
        expect_hash = {}
        expect_hash["key"] = "value"
        expect_hash["child_dot"] = expect_child_hash
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

      it "no error with recursive array with de_dot_nested = false" do
        # "child_dot" => ["test", "test.dot", {"key"=>"value", "key.dot"=>"value.dot"}]
        @filter.recurse = false
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_child_array = []
        test_child_array.push("test")
        test_child_array.push("test.dot")
        test_child_array.push(test_child_hash)
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["child.dot"] = test_child_array
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key.dot"] = test_child_hash["key.dot"]
        expect_child_array = []
        expect_child_array.push("test")
        expect_child_array.push("test.dot")
        expect_child_array.push(expect_child_hash)
        expect_hash = {}
        expect_hash["key"] = "value"
        expect_hash["child_dot"] = expect_child_array
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

      it "no error with recursive array with de_dot_nested = true" do
        # "child_dot" => ["test", "test.dot", {"key"=>"value", "key_dot"=>"value.dot"}]
        @filter.recurse = true
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_child_array = []
        test_child_array.push("test")
        test_child_array.push("test.dot")
        test_child_array.push(test_child_hash)
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["child.dot"] = test_child_array
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key_dot"] = test_child_hash["key.dot"]
        expect_child_array = []
        expect_child_array.push("test")
        expect_child_array.push("test.dot")
        expect_child_array.push(expect_child_hash)
        expect_hash = {}
        expect_hash["key"] = "value"
        expect_hash["child_dot"] = expect_child_array
        expect(@filter.filter("tag", "time", test_hash)).to eq expect_hash
      end

    end

  end

end
