require 'jira4r/jira4r'
require File.dirname(__FILE__) + '/issue'
gem 'soap4r'

class Jira
  def initialize()
    @jira = Jira4R::JiraTool.new(2, "http://jira.toptable.com")
    @jira.login("api", "Agile")

    @types = {}
    @custom_fields = {}

    @jira.getIssueTypes().each  {|t| @types[t.id] = t.name }
    @jira.getCustomFields().each { |f| @custom_fields[f.id] = f.name.downcase.gsub(/ /, '_') }
  end

  def query(jql)
    @jira.getIssuesFromJqlSearch(jql, 10000).collect do |issue|
      Issue.new(issue, @custom_fields, @types)
    end
  end
end
