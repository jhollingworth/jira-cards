class IssuesJqlGenerator
  def generate(options)
    keys = options[:keys]
    #if it's a range
    if !keys.match(/(.*)\-(\d+)\.\.(.*)\-(\d+)/).nil?
      raise "The beginning and end ranges (#{$1}, #{$2}) do not match" if $1 != $3
      keys = ($2.to_i..$4.to_i).collect { |id| "#{$1}-#{id}"}
    else
      keys = keys.split(',')
    end
    keys.collect { |key| "key = \"#{key.strip}\"" } * " or "
  end
end
