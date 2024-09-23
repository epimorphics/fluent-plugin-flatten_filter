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
        @filter.field = "key"
        expect(@filter.flatten({})).to eq Hash.new
      end

      it "no error with non recursive hash" do
        @filter.field = "^key.dot"
        @filter.recurse = false
        test_hash = {}
        test_hash["key"] = "value"
        test_hash["key.dot"] = "value.dot"
        expect_hash = {}
        expect_hash["key"] = test_hash["key"]
        expect_hash["key_dot"] = test_hash["key.dot"]
        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

      it "no error with recursive hash with recurse = false" do
        # "child_dot" => {"key"=>"value", "key.dot"=>"value.dot"}
        @filter.field = "key"
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
        expect_hash["child.dot"] = expect_child_hash
        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

      it "no error with recursive hash with recurse = true" do
        # "child_dot" => {"key"=>"value", "key_dot"=>"value.dot"}
        @filter.field = "^key$"
        @filter.recurse = true
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
        expect_hash["child.dot"] = expect_child_hash
        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

      it "no error with recursive array with recurse = false" do
        # "child_dot" => ["test", "test.dot", {"key"=>"value", "key.dot"=>"value.dot"}]
        @filter.field = "key.dot"
        @filter.recurse = false
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_child_array = []
        test_child_array.push("test")
        test_child_array.push("test.dot")
        test_child_array.push(test_child_hash)
        test_hash = {}
        test_hash["key.dot"] = "value"
        test_hash["child.dot"] = test_child_array
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key.dot"] = test_child_hash["key.dot"]
        expect_child_array = []
        expect_child_array.push("test")
        expect_child_array.push("test.dot")
        expect_child_array.push(expect_child_hash)
        expect_hash = {}
        expect_hash["key_dot"] = "value"
        expect_hash["child.dot"] = expect_child_array
        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

      it "no error with recursive array with recurse = true" do
        # "child_dot" => ["test", "test.dot", {"key"=>"value", "key_dot"=>"value.dot"}]
        @filter.field = "key.dot"
        @filter.recurse = true
        test_child_hash = {}
        test_child_hash["key"] = "value"
        test_child_hash["key.dot"] = "value.dot"
        test_child_array = []
        test_child_array.push("test")
        test_child_array.push("test.dot")
        test_child_array.push(test_child_hash)
        test_hash = {}
        test_hash["key.dot"] = "value"
        test_hash["child.dot"] = test_child_array
        expect_child_hash = {}
        expect_child_hash["key"] = test_child_hash["key"]
        expect_child_hash["key_dot"] = test_child_hash["key.dot"]
        expect_child_array = []
        expect_child_array.push("test")
        expect_child_array.push("test.dot")
        expect_child_array.push(expect_child_hash)
        expect_hash = {}
        expect_hash["key_dot"] = "value"
        expect_hash["child.dot"] = expect_child_array
        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

      it "no error with recursive array with recurse = true" do
        # "child_dot" => ["test", "test.dot", {"key"=>"value", "key_dot"=>"value.dot"}]
        @filter.field = "^app.kubernetes.io/"
        @filter.recurse = true

        test_labels =  {}
        test_labels["app"] = "cstore-api"
        test_labels["app.kubernetes.io/name"] =  "cstore-api"
        test_labels["pod-template-hash"] =  "574dfdc9f7"

        test_kubernetes = {}
        test_kubernetes["container_name"] =  "cstore-api"
        test_kubernetes["namespace_name"] =  "cstore"
        test_kubernetes["pod_name"] =  "cstore-api-574dfdc9f7-9gb95"
        test_kubernetes["container_image"] =  "293385631482.dkr.ecr.eu-west-1.amazonaws.com/epimorphics/cstore-api/uat:0.6.0-SNAPSHOT_a34ac36_00000074"
 
        test_namespace_labels = {}
        test_namespace_labels["kubernetes.io/metadata.name"] = "cstore"
        test_namespace_labels["kustomize.toolkit.fluxcd.io/name"] = "eks-cluster-konf"
        test_namespace_labels["kustomize.toolkit.fluxcd.io/namespace"] = "flux-system"

        test_kubernetes["labels"] = test_labels
        test_kubernetes["namespace_labels"] = test_namespace_labels

        test_hash = {}
        test_hash["kubernetes"] = test_kubernetes

        expect_labels =  {}
        expect_labels["app"] = test_labels["app"]
        expect_labels["app_kubernetes_io/name"] =  "cstore-api"
        expect_labels["pod-template-hash"] = test_labels["pod-template-hash"]

        expect_hash = {}
        expect_kubernetes = {}
        expect_kubernetes["container_name"] =  test_kubernetes["container_name"]
        expect_kubernetes["namespace_name"] =  test_kubernetes["namespace_name"]
        expect_kubernetes["pod_name"] =  test_kubernetes["pod_name"]
        expect_kubernetes["container_image"] =  test_kubernetes["container_image"]

        expect_kubernetes["labels"] = expect_labels
        expect_hash["kubernetes"] = expect_kubernetes
        expect_kubernetes["namespace_labels"] = test_namespace_labels

        expect(@filter.flatten(test_hash)).to eq expect_hash
      end

    end

  end

end
