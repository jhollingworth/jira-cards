require 'rubygems'
require 'ruby-debug'
require 'jira4r/jira4r'
require 'uri'
require 'pdfkit'
gem 'soap4r'

jira = Jira4R::JiraTool.new(2, "http://jira")
jira.login("", "")

query = "project = \"Y Team\" AND fixVersion = \"Iteration 29\" ORDER BY Rank ASC, key ASC"

module Issue

  def business_value
    custom_field("10010")
  end

  def notes
    custom_field("10042")
  end

  def acceptance_criteria
    custom_field("10012")
  end

  def key
    @issue.key
  end

  def to_s
    "Key: #{key}\n\nBusiness value:\n#{business_value}\n\nNotes:\n#{notes}\n\nAcceptance criteria:\n#{acceptance_criteria}\n******************************\n"
  end

  private 

  def custom_field(id)
    @issue.customFieldValues.each do |c|
      if c.customfieldId == "customfield_#{id}"
        return c.values
      end
    end
    nil
  end

end

class Story
  include Issue

  def initialize(issue)
    @issue = issue
  end
end

class Bug
  include Issue
    
  def initialize(issue)
    @issue = issue
  end
end


issues = jira.getIssuesFromJqlSearch(query, 100)

cards = []

issues.each do |i|
  if i.type == "1"
    cards << Bug.new(i)
  elsif i.type == "6"
    cards << Story.new(i)
  end
end

cards.each do |c|
  puts "#{c.class.name}: #{c.key}"
end

html_body = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\"><html><head><title></title></head><body>{BODY}</body></html>"

# config/initializers/pdfkit.rb
PDFKit.configure do |config|
  config.wkhtmltopdf = 'C:\Program Files (x86)\wkhtmltopdf\wkhtmltopdf.exe'
end

kit = PDFKit.new(html_body, :page_size => 'Letter')
kit.to_file 'Test.pdf'







