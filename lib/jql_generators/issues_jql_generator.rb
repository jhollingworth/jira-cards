class IssuesJqlGenerator
  def generate(options)
    
    keys = options[:keys].split(',').collect { |k| k.strip }.collect do |key|
      #if it's a specific key
      if !key.match(/(.*)\-(\d+)\.\.(.*)\-(\d+)/).nil?
        raise "The beginning and end ranges (#{$1}, #{$2}) do not match" if $1 != $3
        ($2.to_i..$4.to_i).collect { |id| "#{$1}-#{id}"}
      elsif !key.match(/(.*\-\d+)/).nil?
        $1
      else
        "Unknown key #{key}"
      end
    end

    keys.flatten.collect { |key| "key = \"#{key}\"" } * " or "
  end
end
