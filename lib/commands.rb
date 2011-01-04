require 'jql_generator'
require 'jira'
require 'html_renderer'
require 'pdf_renderer'
require 'configuration'

class Commands

  class << self

    def config(options = {})
      if options[:reset] == false
        Configuration.reset!(options[:config_path])
      else
        Configuration.print
      end
    end

    def issues(options = {})

      validate_flags(options, :keys, :output)
      print_issues("issues", options)
    end

    def iteration(options = {})
      validate_flags(options, :project, :version, :output)
      
      print_issues("iteration", options)
    end

    private

    def validate_flags(options, *flags)
      error = false
      flags.each do |flag|
        if(options[flag].nil? || options[flag] == "")
          $stderr.puts "--#{flag.to_s} is required"
          error = true
        end
      end

      exit 1 if error
    end

    def print_issues(command, options)
      config = Configuration.new
      jira = Jira.new(config)
      jql = JqlGenerator.generate(command, options)

      html_renderer = HtmlRenderer.new(config)
      pdf_renderer = PdfRenderer.new(config)
      issues = jira.query(jql)

      if issues.length == 0
        puts "No issues found"
        return
      end

      html = html_renderer.render(issues)
      pdf_renderer.render(html, options[:output])
    end
  end
end

