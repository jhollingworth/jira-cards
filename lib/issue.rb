require File.dirname(__FILE__) + '/meta'

class Issue
  include Meta
  attr_reader :issue_type

  def initialize(issue, custom_fields, types)
    @issue = issue
    @issue_type = get_type(types)
    custom_fields.each do |id, name|
      create_method(name) {
        custom_field(id)
      }
    end
  end

  private

  def method_missing(m, *args, &block)
    @issue.send m
  end

  def get_type(types)
    types.each do |id, name|
      return name if @issue.type == id
    end
    nil
  end

  def custom_field(id)
    @issue.customFieldValues.each do |c|
      return c.values if c.customfieldId == id
    end
    nil
  end
end
