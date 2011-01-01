require 'optiflag'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'jql_generator'
require 'jira'
require 'html_renderer'
require 'pdf_renderer'

@command = ARGV[0]
@command.downcase if !@command.nil?

case @command
  when "issues" then
    module Issues extend OptiFlagSet
      flag "keys", :description => "The issue keys you want to turn into cards"
      flag "output", :description => "Path where you want to save the pdf to"
      and_process!
    end
  when "iteration" then
    module Issues extend OptiFlagSet
      flag "project", :description => "The name of the green hopper project"
      flag "version", :description => "The version that you want to print"
      flag "output", :description => "Path where you want to save the pdf to"
    
      and_process!
    end
  else raise "Unknown command. Options are issues, iteration"
end


class Application
  class << self
    def run!(*args)
      jira = Jira.new
      jql = JqlGenerator.generate(ARGV[0], ARGV.flags)

      puts "JQL Query: #{jql}"
      html_renderer = HtmlRenderer.new
      pdf_renderer = PdfRenderer.new

      issues = jira.query(jql)
      html = html_renderer.render(issues)
      pdf_renderer.render(html, ARGV.flags["output"])
    end
  end
end