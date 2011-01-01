require 'jira4r/jira4r'
require File.dirname(__FILE__) + '/issue'
gem 'soap4r'

class Jira
  def initialize(config)
    @jira = Jira4R::JiraTool.new(2, "http://#{config.jira_url}")
    @jira.login(config.username, config.password)

    @types = {}
    @custom_fields = {}

    @jira.getIssueTypes().each  {|t| @types[t.id] = t.name }
    @jira.getCustomFields().each { |f| @custom_fields[f.id] = f.name.downcase.gsub(/ /, '_') }
  end

  def query(jql)
    @jira.getIssuesFromJqlSearch(jql, 10000).collect do |issue|
      issue = Issue.new(issue, @custom_fields, @types)
      puts "Found #{issue.key} (#{issue.issue_type})"
      issue
    end
  end
end
