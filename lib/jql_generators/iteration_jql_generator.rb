require 'ruby-debug'
class IterationJqlGenerator
  def generate(options)
    "project = \"#{options[:project]}\" AND fixVersion = \"#{options[:version]}\""
  end
end