Dir[File.dirname(__FILE__) + '/jql_generators/**/*_generator.rb'].each do |generator|
  require generator
end

class JqlGenerator
  def self.generate(command, options)
    Kernel.const_get("#{command.capitalize}JqlGenerator").new.generate(options) 
  end
end
