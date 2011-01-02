require 'yaml'
require 'net/http'
require 'uri'
require File.dirname(__FILE__) + '/meta'

class Configuration
  include Meta
  def initialize()
    create_config if false == File.exists?(Configuration.config_path)

    YAML.load_file(Configuration.config_path).each do |key, value|
      create_method(key) {
        value
      }
    end
  end

  class << self

    def reset!()
      File.delete(config_path) if File.exists?(config_path)
      Configuration.new
    end

    def config_path()
      File.dirname(__FILE__) + '/config.yml'
    end

    def print()
      if !File.exists?(config_path)
        puts "jira-cards has not been configured yet"
        exit 1
      end
      YAML.load_file(Configuration.config_path).each do |key, value|
        puts "#{key}: #{value}"
      end
    end
  end

  private

  def create_config
    puts "Hi, we need to configure jira-cards. Can you answer some questions please?"
    
    config = {
        "jira_url" => jira_url,
        "username" => username,
        "password" => password,
        "wkhtmltopdf_path" => wkhtmltopdf_path,
        "template_erb" => template_erb,
        "template_stylesheet" => template_stylesheet
    }

    File.open(Configuration.config_path, "w") do |f|
      f.write(config.to_yaml)
    end
  end

  def yaml(hash)
    method = hash.respond_to?(:ya2yaml) ? :ya2yaml : :to_yaml
    string = hash.deep_stringify_keys.send(method)
    string.gsub("!ruby/symbol ", ":").sub("---","").split("\n").map(&:rstrip).join("\n").strip
  end

  def jira_url()
    url = ask "What's the url to your jira instance? e.g. jira.atlassian.com"
    invalid = true
    while invalid
      wsdl_url = "#{url}/rpc/soap/jirasoapservice-v2"
      if url.match(/^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/ix).nil?
        url = ask "The url #{url} is invalid. Please try again. e.g. jira.atlassian.com"
      else
        case Net::HTTP.get_response(url, '/rpc/soap/jirasoapservice-v2')
          when Net::HTTPSuccess then
            invalid = false
          when Net::HTTPServiceUnavailable then
            url = ask "The jira api is disabled. Please enable it, see http://confluence.atlassian.com/display/JIRA/JIRA+XML-RPC+Overview"
          when Net::HTTPNotFound then
            url = ask "Could not find #{wsdl_url}. Please check the url is correct"
          else
            url = ask "There was a problem getting the jira wsdl (#{wsdl_url}). Please check the url is correct"
        end
      end
    end
    url
  end

  def username()
    get_non_empty_value("What is your username for jira (must be an admin)", "username")
  end

  def get_non_empty_value(question, type)
    value = ask question
    invalid = true
    while invalid
      if value == ""
        value = ask "Please specify the #{type}"
      else
        invalid = false
      end
    end
    value
  end

  def password()
    get_non_empty_value("What is the password?", "password")
  end

  def wkhtmltopdf_path()
    get_file_path(
        "What is the path to wkhtmltopdf? e.g. C:\\\\Program Files\\\\wkhtmltopdf\\\\wkhtmltopdf.exe. " +
        "If you don't have it installed, please install from http://code.google.com/p/wkhtmltopdf/",
        "wkhtmltopdf path"
    )
  end

  def get_file_path(question, type)
    path = get_non_empty_value(question, type)

    invalid = true
    while invalid
      if !File.exists?(path)
        path = ask("The file #{path} does not exist")
      else
        invalid = false
      end
    end

    path
  end

  def template_erb()
    invalid = true
    while(invalid)
      @use_default = (ask "Do you want to use the default template? (y/n)").downcase
      if @use_default == "y" || @use_default == "n"
        invalid = false
        @use_default = @use_default == "y"
      end
    end

    if @use_default
      clean_path("default_template.erb")
    else
      get_file_path("What is the path to the template? e.g. c:\\\\foo\\\\template.erb", "template path")
    end
  end

  def template_stylesheet()
    if @use_default
      clean_path("default_template.css")
    else
      get_file_path("What is the path to the template stylesheet? e.g. c:\\\\foo\\\\template.css", "template stylesheet")
    end
  end

  def clean_path(path)
    File.expand_path(File.dirname(__FILE__) + "/" + path).gsub('/', '\\\\\\')
  end

  def ask(question)
    puts question
    STDIN.gets.strip
  end
end