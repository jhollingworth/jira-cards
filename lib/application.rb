require 'commands'
require 'clint'

c = Clint.new

c.usage do
  $stderr.puts "\nA command line tool for generating jira scrum cards (for more help [--h|--help])\n\n"
end

c.help do
  $stderr.puts "config: shows the current jira configuration\n\n\t" +
               "[--r|--reset] if this flag is specified, it will reset the configuration\n\n"
               "[--c|--config_path] if resetting the config, you can use this flag to specify the path to the config file rather than it asking the questions\n\n"

  $stderr.puts "issues: print cards for specific issues\n\n\t" +
               "[--k|--keys] issue keys. they can be csv, e.g. \"foo-1, foo-2\" or a range foo-2..foo-10\n\t" +
               "[--o|--output] output path for pdf e.g. c:\\foo\\temp.pdf\n\n"

  $stderr.puts "iteration: print cards for an iteration\n\n\t" +
               "[--v|--version] the version you want to print e.g. \"Iteration 30\"\n\t" +
               "[--p|--project] the project e.g. \"Some project\"\n\t" +
               "[--o|--output] output path for pdf e.g. c:\\foo\\temp.pdf\n\n"
end

c.options :help => false, :h => :help
c.parse ARGV

if c.options[:help]
  c.help
  exit 1
end

c.subcommand Commands do |subcommand|
  if subcommand == :config
    c.options :reset => true, :r => :reset, :config_path => String, :c => :config_path
  end
  
  if subcommand == :issues
    c.options :keys => String, :k => :keys, :output => String, :o => :output
  end

  if subcommand == :iteration
    c.options :project => String, :p => :project, :version => String, :v => :version, :output => String, :o => :output
  end
  c.parse
end