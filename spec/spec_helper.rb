SPEC_ROOT = File.dirname(__FILE__)

$:.unshift(SPEC_ROOT)
$:.unshift(File.join(SPEC_ROOT, '..', 'lib'))
$:.unshift(File.join(SPEC_ROOT, '..', 'lib', 'jql_generators'))

require 'rubygems'
require 'ftools'

def delete_file(path)
  (0..10).each do
    begin
      File.delete(path) if File.exists?(path)
      return
    rescue
    end
  end
end