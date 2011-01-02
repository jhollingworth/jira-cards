require 'spec_helper'
require 'issues_jql_generator'

describe "Generating issue jql" do

  before(:all) do
    @generator = IssuesJqlGenerator.new
  end

  before(:each) do
    @jql = @generator.generate({:keys => @keys})
  end

  describe "When the issue keys are separated by commas" do
    before(:all) do
      @keys = "py-1, py-3"
    end

    it "should be able to split the keys" do
      @jql.should == "key = \"py-1\" or key = \"py-3\""
    end
  end

  describe "When the issue keys are a range" do
    before(:all) do
      @keys = "py-40..py-42"
    end

    it "should be able to work out the range" do
      @jql.should == "key = \"py-40\" or key = \"py-41\" or key = \"py-42\""
    end
  end

  describe "When the issues keys are ranges separated by commas" do
    before(:all) do
      @keys = "py-1, py-4..py-6, py-14"
    end

    it "should be able to split the keys and work out the range" do
      @jql.should == "key = \"py-1\" or key = \"py-4\" or key = \"py-5\" or key = \"py-6\" or key = \"py-14\""
    end
  end
end
